{ ... }: {
  networking.hostName = "minime"; # Define your hostname.
  networking.useNetworkd = true;
  networking.firewall.enable = true;

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

  systemd.network.enable = true;

  systemd.network.networks = {
    "10-ether-uplink" = {
      matchConfig.name = "enp90s0";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
    };
  };
}
