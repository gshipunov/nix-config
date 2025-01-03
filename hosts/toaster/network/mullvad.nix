{ config, lib, ... }: {
  systemd.network =
    let
      pubkey =  "uUYbYGKoA6UBh1hfkAz5tAWFv4SmteYC9kWh7/K6Ah0=";
      endpoint = "169.150.196.15:51820";
      addr = [ "10.74.16.48/32" "fc00:bbbb:bbbb:bb01::b:102f/128" ];
    in
    {
      netdevs."10-wg-mullvad" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-mullvad";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."wg/mullvad".path;
          FirewallMark = 34952; # 0x8888
          RouteTable = "off";
        };
        wireguardPeers = [
          {
            PublicKey = pubkey;
            Endpoint = endpoint;
            AllowedIPs = [ "0.0.0.0/0" "::0/0" ];
          }
        ];
      };
      networks."10-wg-mullvad" = {
        matchConfig.Name = "wg-mullvad";
        address = addr;
        networkConfig = {
          DNS = "10.64.0.1";
          DNSDefaultRoute = true;
          Domains = [ "~." ];
        };
        routes = map
        (gate: {
            Gateway = gate;
            Table = 1000;
        }) [
          "0.0.0.0"
          "::"
        ];

        routingPolicyRules = [ {
          Family = "both";
          FirewallMark = 34952; # 0x8888
          InvertRule = true;
          Table = "1000";
          Priority = 100;
        }
        {
          Family = "both";
          SuppressPrefixLength = 0;
          Table = "main";
          Priority = 90;
        } ] ++ map (net: {
          # only route global addresses over VPN
          Priority = 80;
          To = net;
        }) [
        # Mullvad endpoint
        "92.60.40.209/32"
        # "10.0.0.0/8"
        "10.13.37.0/24"
        "10.66.66.0/24"
        # "172.16.0.0/12"
        "172.16.0.0/12"
        # "182.168.0.0/16"
        "182.168.0.0/16"
        # "fc00::/7"
      ];
    };
  };
}
