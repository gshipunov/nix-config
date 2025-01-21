{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.fstrim.enable = true;
  services.zfs = {
    autoSnapshot.enable = true;
    trim.enable = true;
    autoScrub = {
      enable = true;
      pools = [ "zpool" ];
    };
  };
  networking.hostId = "dca22577";
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
    zfs.package = pkgs.zfs_2_3;
    supportedFilesystems = [ "zfs" ];
    kernelParams = [ "nohibernate" ];
    plymouth.enable = false;
    tmp.useTmpfs = true;
  };
}
