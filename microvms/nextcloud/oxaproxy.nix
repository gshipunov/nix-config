{ config, ... }: {
  networking.wireguard.enable = true;
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    netdevs."10-oxaproxy" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "oxaproxy";
        Description = "oxa's enterprise reverse-proxy network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg/oxaproxy-seckey".path;
        #own pubkey: KCYoGx7TGei4X79EZo2NONCcmQjPzBUN1Ds6I9lQbz0=
      };
      wireguardPeers = [
        {
          # cirrus
          wireguardPeerConfig = {
            PublicKey = "0KMtL2fQOrrCH6c2a2l4FKiM73G86sUuyaNj4FarzVM=";
            AllowedIPs = [ "10.34.45.0/24" ];
            Endpoint = [ "95.216.166.21:51821" ];
            PersistentKeepalive = 25;
          };
        }
      ];
    };
    networks."10-oxaproxy" = {
      matchConfig.Name = "oxaproxy";
      networkConfig = {
        Address = "10.34.45.100/24";
      };
    };

    networks."111-host" = {
      matchConfig.MACAddress = "02:00:00:00:00:00";
      networkConfig = {
        Address = "10.99.99.100/24";
      };
      routes = [
        {
          routeConfig = {
            Gateway = "10.99.99.1";
            Destination = "0.0.0.0/0";
            Metric = 1024;
          };
        }
        {
          routeConfig = {
            Gateway = "10.99.99.1";
            Destination = "10.99.99.0/24";
            Metric = 1024;
          };
        }
      ];
    };
  };
}
