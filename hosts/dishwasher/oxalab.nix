{ config, ... }:
{
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
      };
      wireguardPeers = [
        {
          # cirrus
          wireguardPeerConfig = {
          PublicKey = "5nCVC21BL+1r70OGwA4Q6Z/gcPLC3+ZF8sTurdn7N0E=";
          AllowedIPs = [ "10.66.66.0/24" ];
          Endpoint = [ "95.216.166.21:51820" ];
          PersistentKeepalive = 25;
        };
        }
      ];
    };
    networks."oxalab" = {
      matchConfig.Name = "oxalab";
      networkConfig = {
        Address = "10.66.66.100";
      };
    };
  };
}
