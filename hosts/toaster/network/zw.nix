{ config, ... }: {
    # zentralwerk
    systemd.network = {
      netdevs."10-wg-zentralwerk" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-zentralwerk";
          Description = "Tunnel to the best basement in Dresden";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."wg/zw".path;
          RouteTable = "off";
        };
        wireguardPeers = [
          {
            PublicKey = "PG2VD0EB+Oi+U5/uVMUdO5MFzn59fAck6hz8GUyLMRo=";
            Endpoint = "81.201.149.152:1337";
            AllowedIPs = [ "172.20.72.0/21" "172.22.90.0/24" "172.22.99.0/24" ];
            PersistentKeepalive = 25;
          }
        ];
      };
      networks."10-wg-zentralwerk" = {
        matchConfig.Name = "wg-zentralwerk";
        networkConfig = {
          Address = "172.20.76.226/21";
          IPv6AcceptRA = true;
          DNS = "172.20.73.8";
          Domains = [
            "~hq.c3d2.de"
            "~serv.zentralwerk.org"
            "~hq.zentralwerk.org"
            "~cluster.zentralwerk.org"
          ];
        };
        routes = [
          {
            Gateway = "172.20.76.225";
            Destination = "172.20.72.0/21";
            Metric = 1023;
          }
          {
            Gateway = "172.20.76.225";
            Destination = "172.20.90.0/24";
            Metric = 1023;
          }
          {
            Gateway = "172.20.76.225";
            Destination = "172.22.99.0/24";
            Metric = 1023;
          }

        ];
      };
    };
  }
