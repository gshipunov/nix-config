# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  zramSwap = { enable = true; algorithm = "zstd"; };

  networking = {
    hostName = "cirrus"; # Define your hostname.
  };

  systemd.network = {
    enable = true;
    networks."uplink" = {
      matchConfig = { Name = "enp1s0"; };
      networkConfig = {
        Address = "95.216.166.21/32";
        Gateway = "172.31.1.1";
        DNS = "1.1.1.1";
      };
    };
  };


  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the OpenSSH daemon.
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDP6xE2ey0C8XXfvniiiHiqXsCC277jKI9RXEA+s2LQLUI5zl7v350i3Oa8H3NCcPj39lfMreqE6ncxcOhqYyzahPrrMkOqgbPAoRvq8H3ophLK+56O3xdHoKwLBwRD1yoGACjqG4UTiTrmnN2ateENgYcnTEY1e4vDw1qMj1drUXCsZ/6mkBBmHJiFfCaR4yCMt1r4gGi/dAC7ifnBP3oSyV/lJEwPxYYkGlbOBIvX/7Ar98pJS6xYPB3jHs9gwyNNON63d0fNYrwBojXPPCnGGaRZNOkBTzex3zZYp12ThINQ2xl8tRp9D8qpZ7vrLjhTD6AXkOBRzmDj+NsCeEaeTuWajqUM93iKncYUI+JxR1t7q8gA2pBMFzLesMXnx7R+5Kw7QDtSJM7a4GMIfsocPwf64BH6rzxEz68rXFE3P+J77PPM9CuaYw90JXHo3z220zYw2nMQ/1qjATVZw/hiVrLmQMVfmFJIufnGjTBs2sy3IoNyzvYm/oDeNNg1cdSV9gyyRKZhK08fxjXN5GSf9vZkfZa9tHtqaZ99HI40GQBHUVx1K2/NQJY8TVTSA+v16SFnJK8BIbmp/WFCuvDcMkgLIbqiYtDASe7P2mKIib86uOENT+P820egeLiTQ06kFw/gfUa8t69d5qEcjiQZ+lxCeYIs/E9KrEXHvRUWew== cardno:16 811 348"
  ];

  # enable openssh
  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

