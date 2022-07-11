{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    iwgtk
  ];
  networking = {
    hostName = "microwave"; # Define your hostname.
    firewall.enable = true;
    useNetworkd = true;
    wireguard.enable = true;
    wireless.iwd = {
      enable = true;
    };
  };

  services.resolved = {
    enable = true;
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
      networks."10-ether" = {
        matchConfig = { Name = "enp53s0"; };
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
        };
      };
      networks."10-wlan" = {
        matchConfig = { Name = "wlan0"; };
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
          IgnoreCarrierLoss = true;
        };
      };

      # Wireguard
      # Dump-dvb
      netdevs."10-wg-dumpdvb" = {
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
      networks."10-wg-dumpdvb" = {
        matchConfig = { Name = "wg-dumpdvb"; };
        networkConfig = {
          Address = "10.13.37.3";
          IPv6AcceptRA = true;
        };
        routes = [
          { routeConfig = { Gateway = "10.13.37.1"; Destination = "10.13.37.0/24"; }; }
        ];
      };

      # Dump-dvb
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
        matchConfig = { Name = "wg-oxalab"; };
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
        };
        wireguardPeers = [
          {
            wireguardPeerConfig = {
              PublicKey = "PG2VD0EB+Oi+U5/uVMUdO5MFzn59fAck6hz8GUyLMRo=";
              Endpoint = "81.201.149.152:1337";
              AllowedIPs = [ "172.20.72.0/21" "172.22.90.0/24" ];
              PersistentKeepalive = 25;
            };
          }
        ];
      };
      networks."10-wg-zentralwerk" = {
        matchConfig = { Name = "wg-zentralwerk"; };
        networkConfig = {
          Address = "172.20.76.226";
          IPv6AcceptRA = true;
          DNS = "172.20.73.8";
        };
        routes = [
          {
            routeConfig = {
              Gateway = "172.20.72.4";
              Destination = "172.20.72.0/21";
            };
          }
          {
            routeConfig = {
              Gateway = "172.20.72.4";
              Destination = "172.20.90.0/24";
            };
          }
        ];
      };
    };
  }
