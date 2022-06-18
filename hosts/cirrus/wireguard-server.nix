{ config, ... }:
{
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard.enable = true;
  systemd.network = {
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
          PublicKey = "xrremJFIcxwR6snoTUK+mytjez60I91XE120OQGQ7gc=";
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
      };
    };
  };
}
