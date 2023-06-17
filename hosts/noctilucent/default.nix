{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  zramSwap = { enable = true; algorithm = "zstd"; };

  networking = {
    hostName = "noctilucent"; # Define your hostname.
  };

  systemd.network = {
    enable = true;
    networks."uplink" = {
      matchConfig = { Name = "enp1s0"; };
      networkConfig = {
        Address = "91.107.193.99/32";
        DNS = "9.9.9.9";
      };
      routes = [
        {
          routeConfig = {
            Gateway = "172.31.1.1";
            GatewayOnLink = true;
            Destination = "0.0.0.0/0";
          };
        }
      ];
    };
  };


  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

