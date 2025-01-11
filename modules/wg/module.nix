{
  lib,
  config,
  self,
  registry,
  ...
}:
{

  config =
    let
      currenthost = config.networking.hostName;
      wg = config.oxalab.wg;

      # get all the networks we participate in
      networks = builtins.filter (net: builtins.hasAttr "${currenthost}" net.hosts) wg;

      # create wg networks
      network-attrset = map (net: {
        name = "30-wg-${net.networkName}";
        value = {
          matchConfig.Name = "wg-${net.networkName}";
          networkConfig =
            {
              Address = net.hosts.${currenthost}.address;
              IPv6AcceptRA = false; # for now static IPv6
            }
            // (
              if net.hosts.${currenthost}.endpoint.enable then
                {
                  IPv4Forwarding = true;
                  IPv6Forwarding = true;
                }
              else
                { }
            );
        };
      }) networks;

      systemd-networks = builtins.listToAttrs network-attrset;

      # get all the networks we client in
      net-client = builtins.filter (net: !net.hosts.${currenthost}.endpoint.enable) networks;
      # get all the networks we are endpoint of
      net-endpoint = builtins.filter (net: net.hosts.${currenthost}.endpoint.enable) networks;

      # wg netdevs
      # client
      netdev-client-list = map (net: {
        name = "30-wg-${net.networkName}";
        value = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg-${net.networkName}";
          };
          wireguardConfig.PrivateKeyFile = net.hosts.${currenthost}.privateKeyFile;
          # for client this is only endpoint for now
          wireguardPeers =
            let
              endpoint = lib.attrsets.filterAttrs (_k: v: v.endpoint.enable) net.hosts;
              wg-peers-attrs = lib.attrsets.mapAttrs (_k: v: {
                PersistentKeepalive = 29;
                PublicKey = v.publicKey;
                Endpoint = "${v.endpoint.endpoint}:${toString v.endpoint.port}";
                AllowedIPs = net.CIDRs;
              }) endpoint;
              wg-peers = lib.attrsets.attrValues wg-peers-attrs;
            in
            wg-peers;
        };
      }) net-client;
      netdev-client = builtins.listToAttrs netdev-client-list;

      maskip = (
        net: hostattrs:
        if hostattrs.endpoint.enable then
          hostattrs.address
        else
          map (baseaddr: if lib.strings.hasInfix "." baseaddr then "${baseaddr}/32" else "${baseaddr}/128") (
            map (addr: builtins.elemAt (lib.strings.splitString "/" addr) 0) hostattrs.address
          )
      );
      # endpoint
      # TODO: this requires bit more logic for allowedIPs if we have more then
      # 2 endpoints e.g. for routing client -> endpoint1 -> endpoint2 ->
      # client2
      netdev-endpoint-list = map (net: {
        name = "30-wg-${net.networkName}";
        value = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg-${net.networkName}";
          };
          wireguardConfig.PrivateKeyFile = net.hosts.${currenthost}.privateKeyFile;
          wireguardConfig.ListenPort = net.hosts.${currenthost}.endpoint.port;
          wireguardPeers =
            let
              peers = lib.attrsets.filterAttrs (k: _v: k != currenthost) net.hosts;
              wg-peers-attrs = lib.attrsets.mapAttrs (
                _k: v:
                {
                  PersistentKeepalive = 29;
                  PublicKey = v.publicKey;
                  # only route to /32 or /128, i.e. single client
                  AllowedIPs = maskip net v;
                }
                // (
                  if !isNull v.endpoint.endpoint then
                    { Endpoint = "${v.endpoint.endpoint}:${toString v.endpoint.port}"; }
                  else
                    { }
                )
              ) peers;
              wg-peers = lib.attrsets.attrValues wg-peers-attrs;
            in
            wg-peers;
        };
      }) net-endpoint;
      netdev-endpoint = builtins.listToAttrs netdev-endpoint-list;

    in
    {
      # make sure that the networkd and wg are enabled
      networking.wireguard.enable = true;
      systemd.network.enable = true;

      systemd.network.networks = systemd-networks;
      systemd.network.netdevs = netdev-client // netdev-endpoint;
    };
}
