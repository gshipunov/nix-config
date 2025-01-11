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
      interval = "weekly";
      randomizedDelaySec = "6h";
    };
  };
  networking.hostId = "41ba28ff";
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

  # unlock over ssh
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      hostKeys = [ /etc/secrets/initrd/ssh_host_rsa_key ];
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJl9iYG5oHBq/poBn7Jf1/FGWWbAnbx+NKjs7qtT3uAK 0xa@toaster 2024-12-31"
      ];
    };
    postCommands = ''
      zpool import -a
      echo "zfs load-key -a; killall zfs" >> /root/.profile
    '';
  };
  # support for network
  boot.initrd.kernelModules = [
    "igc"
    "i40e"
    "mt7921e"
  ];
  boot.kernelModules = [
    "igc"
    "i40e"
    "mt7921e"
  ];
}
