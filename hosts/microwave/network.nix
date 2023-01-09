{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    iwgtk
  ];
  networking = {
    hostName = "microwave"; # Define your hostname.
    hostId = "7da4f1e6";
    firewall.enable = true;
    networkmanager.enable = false;
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
  };
}
