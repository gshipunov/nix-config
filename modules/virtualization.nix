{ config, pkgs, inputs, ... }:
let
  overlay-qemu_full-stable = final: prev: {
    qemu_full = inputs.nixpkgs-stable.legacyPackages."x86_64-linux".qemu_full;
  };
in
{
  nixpkgs.overlays = [ overlay-qemu_full-stable ];
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
