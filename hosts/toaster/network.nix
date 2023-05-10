{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ iwgtk ];

  networking = {
    hostName = "toaster";
    firewall.enable = true;
    networkmanager.enable = false;
    useNetworkd = true;
    wireguard.enable = true;
    wireless.iwd.enable = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [
      "9.9.9.9"
      "2620:fe::fe"
      "149.112.112.112"
      "2620:fe::9"
    ];
  };

  # workaround for networkd waiting for shit
  systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [
    "" # clear old command
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  systemd.network = {
    enable = true;

    networks."10-ether" = {
      matchConfig.MACAddress = "e8:80:88:2f:c6:70";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
    };
    networks."10-dock" = {
      matchConfig.Name = "enp5s0f4u1u1";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
      dhcpV4Config = { RouteMetric = 666; };
    };
    networks."10-wlan" = {
      # matchConfig.MACAddress = "04:7b:cb:2a:aa:8c";
      matchConfig.Name = "wlan0";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
    };
  };
}
