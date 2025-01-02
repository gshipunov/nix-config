{ pkgs, ... }: {
  users.users."0xa".extraGroups = [ "networkmanager" ];

  networking = {
    hostName = "toaster";
    firewall.enable = true;
    wireguard.enable = true;
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

}
