{ config, ... }: {
  systemd.network = {
    # Wireguard
    # Dump-dvb
    netdevs."30-wg-dumpdvb" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-dumpdvb";
        Description = "dvb.solutions enterprise network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg/dvb".path;
      };
      wireguardPeers = [
        {
          PublicKey = "WDvCObJ0WgCCZ0ORV2q4sdXblBd8pOPZBmeWr97yphY=";
          Endpoint = "academicstrokes.com:51820";
          AllowedIPs = [ "10.13.37.0/24" ];
          PersistentKeepalive = 25;
        }
      ];
    };
    networks."30-wg-dumpdvb" = {
      matchConfig.Name = "wg-dumpdvb";
      networkConfig = {
        Address = "10.13.37.3/24";
        IPv6AcceptRA = true;
      };
      routes = [
        { Gateway = "10.13.37.1"; Destination = "10.13.37.0/24";  }
      ];
    };
  };
}
