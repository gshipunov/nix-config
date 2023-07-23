{ config, ... }:
{
  networking.firewall = {
    allowedUDPPorts = [
      # wireguards
      51820
      51821
      34197
    ];
    allowedTCPPorts = [
      # port forward ssh to music
      2020
    ];
    # port-forward ssh to the music machine
    extraCommands = ''
      iptables -t nat -I PREROUTING -p tcp --dport 2020 -j DNAT --to-destination 10.34.45.101:22
      iptables -t nat -I PREROUTING -p udp --dport 34197 -j DNAT --to-destination 10.34.45.111:34197
      iptables ! -o lo -t nat -A POSTROUTING -j MASQUERADE
    '';
    extraStopCommands = ''
      iptables -t nat -D PREROUTING -p tcp --dport 2020 -j DNAT --to-destination 10.34.45.101:22 || true
      iptables -t nat -D PREROUTING -p udp --dport 34197 -j DNAT --to-destination 10.34.45.111:34197 || true
    '';
  };


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
          # toaster
          wireguardPeerConfig = {
            PublicKey = "0zpfcNrmbsNwwbnDDX4SMl4BVTB0zuhGKixT9TJQoHc=";
            AllowedIPs = [ "10.66.66.10/32" ];
            PersistentKeepalive = 25;
          };
        }
        {
          # Dishwasher
          wireguardPeerConfig = {
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
        # music
        {
          wireguardPeerConfig = {
            PublicKey = "vQNkp51S9qLsu97dLPj0/EqFwvVtRFZpMHufgKhxum0=";
            AllowedIPs = [ "10.34.45.101/32" ];
            PersistentKeepalive = 25;
          };
        }
        # news
        {
          wireguardPeerConfig = {
            PublicKey = "guzNmsPcQw4EGSLU3X0SP+WPKAcoMc+xv9SLWdHV1V0=";
            AllowedIPs = [ "10.34.45.102/32" ];
            PersistentKeepalive = 25;
          };
        }
        {
          wireguardPeerConfig = {
            PublicKey = "6rwSThPEfTyYvMVSnHNcNPRntCHEQFyscF2SodI8A34=";
            AllowedIPs = [ "10.34.45.111/32" ];
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
