{ config, ... }: {

  networking.wireguard.enable = true;
  networking.useNetworkd = true;

  #oxaproxy secret
  sops.defaultSopsFile = ../../secrets/news/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."oxaproxy-seckey" = {
    owner = config.users.users.systemd-network.name;
  };

  systemd.network = {
    enable = true;
    netdevs."10-oxaproxy" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "oxaproxy";
        Description = "oxa's enterprise reverse-proxy network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."oxaproxy-seckey".path;
        #own pubkey: guzNmsPcQw4EGSLU3X0SP+WPKAcoMc+xv9SLWdHV1V0=
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
        Address = "10.34.45.102/24";
      };
    };

    networks."111-host" = {
      matchConfig.MACAddress = (builtins.elemAt config.microvm.interfaces 0).mac;
      networkConfig = {
        Address = "10.99.99.102/24";
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
