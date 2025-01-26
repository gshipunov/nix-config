{
  pkgs,
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
    kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
    zfs.package = pkgs.zfs_2_3;
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
