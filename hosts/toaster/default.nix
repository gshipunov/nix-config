{ pkgs, ... }: {
  imports = [
    ./amd.nix
    ./amdgpu-sg-fix.nix
    ./hardware-configuration.nix
    ./irc.nix
    ./network-vpns.nix
    ./network.nix
    ./secrets.nix
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

  users.users.grue = {
    extraGroups = [
      "wheel"
      "video"
      "plugdev"
      "dialout"
      "bluetooth"
    ];
    group = "users";
    home = "/home/grue";
    isNormalUser = true;
    uid = 1000;
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    factorio
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
