{ pkgs, ... }: {
  services.fstrim.enable = true;
  services.zfs = {
    autoSnapshot.enable = true;
    trim.enable = true;
    autoScrub = {
      enable = true;
      pools = [ "toasterpool" ];
    };
  };
  networking.hostId = "dca22577";
  boot = {
    kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
    supportedFilesystems = [ "zfs" ];
    kernelParams = [ "nohibernate" ];
    plymouth.enable = false;
    tmp.useTmpfs = true;
  };
}
