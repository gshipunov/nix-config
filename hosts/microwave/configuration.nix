# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
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
    element-desktop-wayland
  ];


  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
    supportedFilesystems = [ "zfs" ];
    kernelParams = [ "nohibernate" ];
    zfs.devNodes = "/dev/";
    plymouth.enable = false;
  };

  services.zfs = {
    trim.enable = true;
    autoScrub = {
      enable = true;
      pools = [ "rpool" ];
    };
    autoSnapshot.enable = true;
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
  time.timeZone = "Europe/Berlin";


  programs.steam.enable = true;

  services.udev.extraRules = ''
      # MCH2022 Badge
      SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="0f9a", MODE="0666"

      #Flipper Zero serial port
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
      #Flipper Zero DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess"
      #Flipper ESP32s2 BlackMagic
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="40??", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
  '';


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

