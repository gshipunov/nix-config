{ pkgs, ... }: {
  imports = [
    ./amd.nix
    ./amd-new-pstate.nix
    ./hardware-configuration.nix
    # ./irc.nix
    ./network
    ./secrets.nix
    ./secure-boot.nix
    ./zfs.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableAllFirmware = true;

  # update the firmware
  services.fwupd.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "all" ];
  };

  users.users."0xa" = {
    extraGroups = [
      "wheel"
      "video"
      "plugdev"
      "dialout"
      "bluetooth"
      "libvirtd"
      "qemu-libvirtd"
    ];
    group = "users";
    home = "/home/0xa";
    isNormalUser = true;
    uid = 1000;
  };

  services.emacs.defaultEditor = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
