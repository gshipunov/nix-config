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
    kernelPackages =
      let
        zfsCompatibleKernelPackages = lib.filterAttrs (
          name: kernelPackages:
          (builtins.match "linux_[0-9]+_[0-9]+" name) != null
          && (builtins.tryEval kernelPackages).success
          && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
        ) pkgs.linuxKernel.packages;
        latestKernelPackage = lib.last (
          lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
            builtins.attrValues zfsCompatibleKernelPackages
          )
        );
      in
      latestKernelPackage;
    supportedFilesystems = [ "zfs" ];
    kernelParams = [ "nohibernate" ];
    plymouth.enable = false;
    tmp.useTmpfs = true;
  };
}
