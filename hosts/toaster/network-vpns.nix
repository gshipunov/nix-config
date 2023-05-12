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
          wireguardPeerConfig = {
            PublicKey = "WDvCObJ0WgCCZ0ORV2q4sdXblBd8pOPZBmeWr97yphY=";
            Endpoint = "academicstrokes.com:51820";
            AllowedIPs = [ "10.13.37.0/24" ];
            PersistentKeepalive = 25;
          };
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
        { routeConfig = { Gateway = "10.13.37.1"; Destination = "10.13.37.0/24"; }; }
      ];
    };

    # oxalab
    netdevs."10-wg-oxalab" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-oxalab";
        Description = "lab of oxa";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg/oxalab".path;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "5nCVC21BL+1r70OGwA4Q6Z/gcPLC3+ZF8sTurdn7N0E=";
            Endpoint = "95.216.166.21:51820";
            AllowedIPs = [ "10.66.66.0/24" ];
            PersistentKeepalive = 25;
          };
        }
      ];
    };
    networks."10-wg-oxalab" = {
      matchConfig.Name = "wg-oxalab";
      networkConfig = {
        Address = "10.66.66.10/24";
        IPv6AcceptRA = true;
      };
      routes = [
        { routeConfig = { Gateway = "10.66.66.1"; Destination = "10.66.66.1/24"; }; }
      ];
    };


    # zentralwerk
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
          wireguardPeerConfig = {
            PublicKey = "PG2VD0EB+Oi+U5/uVMUdO5MFzn59fAck6hz8GUyLMRo=";
            Endpoint = "81.201.149.152:1337";
            AllowedIPs = [ "172.20.72.0/21" "172.22.90.0/24" "172.22.99.0/24" ];
            PersistentKeepalive = 25;
          };
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
          routeConfig = {
            Gateway = "172.20.76.225";
            Destination = "172.20.72.0/21";
            Metric = 1023;
          };
        }
        {
          routeConfig = {
            Gateway = "172.20.76.225";
            Destination = "172.20.90.0/24";
            Metric = 1023;
          };
        }
        {
          routeConfig = {
            Gateway = "172.20.76.225";
            Destination = "172.22.99.0/24";
            Metric = 1023;
          };
        }

      ];
    };

    # VPN
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
          wireguardPeerConfig = {
            PublicKey = "BChJDLOwZu9Q1oH0UcrxcHP6xxHhyRbjrBUsE0e07Vk=";
            Endpoint = "169.150.196.15:51820";
            AllowedIPs = [ "0.0.0.0/0" "::0/0" ];
          };
        }
      ];
    };
    networks."10-wg-mullvad" = {
      matchConfig.Name = "wg-mullvad";
      address = [ "10.66.157.228/32" "fc00:bbbb:bbbb:bb01::3:9de3/128" ];
      networkConfig = {
        DNS = "10.64.0.1";
        DNSDefaultRoute = true;
        Domains = [ "~." ];
      };
      routes = map
        (gate: {
          routeConfig = {
            Gateway = gate;
            Table = 1000;
          };
        }) [
        "0.0.0.0"
        "::"
      ];

      routingPolicyRules = [
        {
          routingPolicyRuleConfig = {
            Family = "both";
            FirewallMark = 34952; # 0x8888
            InvertRule = true;
            Table = "1000";
            Priority = 100;
          };
        }
        {
          routingPolicyRuleConfig = {
            Family = "both";
            SuppressPrefixLength = 0;
            Table = "main";
            Priority = 90;
          };
        }
      ] ++ map
        (net: {
          # only route global addresses over VPN
          routingPolicyRuleConfig = {
            Priority = 80;
            To = net;
          };
        }) [
        # Mullvad endpoint
        "169.150.196.15/32"
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
