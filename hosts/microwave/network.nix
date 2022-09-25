{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    iwgtk
  ];
  networking = {
    hostName = "microwave"; # Define your hostname.
    hostId = "7da4f1e6";
    firewall.enable = true;
    useNetworkd = true;
    wireguard.enable = true;
    wireless.iwd = {
      enable = true;
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
  };

  # workaround for networkd waiting for shit
  systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [
    "" # clear old command
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  systemd.network = {
    enable = true;

    # wait-online.ignoredInterfaces = [ "wlan0" "enp53s0" ];

    # Interfaces on the machine
    netdevs."10-james" = {
      netdevConfig = {
        Name = "james";
        Kind = "bond";
      };
      bondConfig = {
        Mode = "active-backup";
        PrimaryReselectPolicy = "always";
        MIIMonitorSec = "1s";
      };
    };
    networks."10-ether-bond" = {
      matchConfig.Name = "enp53s0";
      networkConfig = {
        Bond = "james";
        PrimarySlave = true;
      };
    };
    networks."10-wlan-bond" = {
      matchConfig.Name = "wlan0";
      networkConfig = {
        Bond = "james";
      };
    };
    networks."10-james-bond" = {
      matchConfig.Name = "james";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
    };

    # Wireguard
    # Dump-dvb
    netdevs."30-wg-dumpdvb" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-dumpdvb";
        Description = "dvb.solutions enterprise network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg/wg-dvb-seckey".path;
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
        PrivateKeyFile = config.sops.secrets."wg/oxalab-seckey".path;
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
        PrivateKeyFile = config.sops.secrets."wg/wg-zw-seckey".path;
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
            Metric = 9999;
          };
        }
        {
          routeConfig = {
            Gateway = "172.20.76.225";
            Destination = "172.20.90.0/24";
            Metric = 9999;
          };
        }
        {
          routeConfig = {
            Gateway = "172.20.76.225";
            Destination = "172.22.99.0/24";
            Metric = 9999;
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
        PrivateKeyFile = config.sops.secrets."wg/mlwd-nl-seckey".path;
        FirewallMark = 34952; # 0x8888
        RouteTable = "off";
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "uUYbYGKoA6UBh1hfkAz5tAWFv4SmteYC9kWh7/K6Ah0=";
            Endpoint = "92.60.40.209:51820";
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
        # Public
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
