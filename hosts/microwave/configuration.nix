# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  # SWAP
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  environment.systemPackages = with pkgs; [
    tdesktop
    signal-desktop
    cubicsdr
    kicad
    gimp
    inkscape
  ];

  networking.firewall.enable = true;
  networking = {
    hostName = "microwave"; # Define your hostname.
    networkmanager.enable = true;
    wireguard.enable = true;

  };


  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;

  boot = {
    supportedFilesystems = [ "btrfs" ];

    # use systemd boot by default
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmpOnTmpfs = true;
    plymouth.enable = false;
  };

  # update the microcode
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  # Shell config (bash)
  programs.bash = {
    enableCompletion = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Users
  users.users.grue = {
    createHome = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "wireshark"
      "video"
      "libvirtd"
      "plugdev"
      "dialout"
      "bluetooth"
    ];
    group = "users";
    home = "/home/grue";
    isNormalUser = true;
    uid = 1000;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };


  programs.steam.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

