{ config, ... }:
{
  networking.firewall.allowedUDPPorts = [ 51820 51821 ];
  networking.wireguard.enable = true;
  systemd.network = {
    # oxalab
    netdevs."oxalab" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "oxalab";
        Description = "oxa's enterprise network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg/oxalab-seckey".path;
        ListenPort = 51820;
        # own pubkey: 5nCVC21BL+1r70OGwA4Q6Z/gcPLC3+ZF8sTurdn7N0E=
      };
      wireguardPeers = [
        {
          # microwave
          wireguardPeerConfig = {
            # nextcloud down, have to keep things in here: https://www.youtube.com/watch?v=1c6v7j1TUBI
            PublicKey = "0zpfcNrmbsNwwbnDDX4SMl4BVTB0zuhGKixT9TJQoHc=";
            AllowedIPs = [ "10.66.66.10/32" ];
            PersistentKeepalive = 25;
          };
        }
        {
          # Dishwasher
          wireguardPeerConfig = {
            # nextcloud down, have to keep things in here: https://www.youtube.com/watch?v=1c6v7j1TUBI
            PublicKey = "AdWUBbyeRkxdP9HUu25PpISoxbgQ8oeCw3BmV93xtAw=";
            AllowedIPs = [ "10.66.66.100/32" ];
            PersistentKeepalive = 25;
          };
        }
      ];
    };
    networks."oxalab" = {
      matchConfig.Name = "oxalab";
      networkConfig = {
        Address = "10.66.66.1/24";
        IPForward = "ipv4";
      };
    };


    # oxaproxy
    netdevs."oxaproxy" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "oxaproxy";
        Description = "oxa's enterprise reverse-proxy network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg/oxaproxy-seckey".path;
        #own pubkey 0KMtL2fQOrrCH6c2a2l4FKiM73G86sUuyaNj4FarzVM=
        ListenPort = 51821;
      };
      wireguardPeers = [
        # nextcloud
        {
          wireguardPeerConfig = {
            PublicKey = "KCYoGx7TGei4X79EZo2NONCcmQjPzBUN1Ds6I9lQbz0=";
            AllowedIPs = [ "10.34.45.100/32" ];
            PersistentKeepalive = 25;
          };
        }
      ];
    };
    networks."oxaproxy" = {
      matchConfig.Name = "oxaproxy";
      networkConfig = {
        Address = "10.34.45.1/24";
      };
    };
  };
}
