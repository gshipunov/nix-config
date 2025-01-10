{ lib, config, ... }: {
  imports = [
    ./mullvad.nix
    ./dumpdvb.nix
    ./zw.nix
  ];

  # Networkmanager shouldn't interfere with systemd managed interfaces
  networking.networkmanager.unmanaged =
    let
      systemd_netdevs = lib.attrsets.attrValues (lib.attrsets.mapAttrs (_name: value: value.netdevConfig.Name) config.systemd.network.netdevs);
    in
    systemd_netdevs;

    systemd.network = {
      enable = true;
      wait-online.enable = false; # uplink is managed by networkmanager
    };

    users.users."0xa".extraGroups = [ "networkmanager" ];

    networking = {
      hostName = "toaster";
      firewall.enable = true;
      wireguard.enable = true;
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

  }
