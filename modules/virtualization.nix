{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    virt-manager
    bridge-utils
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # virtualization
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.runAsRoot = true;
      qemu.package = pkgs.qemu_full;
    };
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}
