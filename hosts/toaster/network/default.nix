{ lib, config, pkgs, ... }: {
  imports = [
    ./mullvad.nix
    ./dumpdvb.nix
    ./zw.nix
  ];

  # kick out networkmanager
  networking.networkmanager.enable = lib.mkForce false;
  networking.useNetworkd = true;
  systemd.network.enable = true;

  networking = {
    hostName = "toaster";
    firewall.enable = true;
    wireguard.enable = true;
    wireless.iwd.enable = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
    fallbackDns = [
      "9.9.9.9"
      "2620:fe::fe"
      "149.112.112.112"
      "2620:fe::9"
    ];
  };

  # we might have no interwebs at all
  systemd.network.wait-online.enable = false;

  # uplinks
  systemd.network.networks = {
    "10-ether-uplink" = {
      matchConfig.Name = "enp1s0f0";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
    };
    "10-dock-uplink" = {
      matchConfig.Name = "enp5s0f4u1u1";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
      dhcpV4Config = { RouteMetric = 666; };
      dhcpV6Config = { RouteMetric = 666; };
    };
    "wlan-uplink" = {
      matchConfig.Name = "wlan0";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
    };
  };

}
