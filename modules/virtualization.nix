{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    virtmanager
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # virtualization
  boot.kernelModules = [ "kvm-intel" ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
      qemu.package = pkgs.qemu_full;
    };
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}
