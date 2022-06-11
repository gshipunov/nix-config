{ pkgs, lib, ... }:
{

  environment.systemPackages = with pkgs; [ nfs-utils ];
  services.rpcbind.enable = true;

  systemd.mounts = [{
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
    what = "10.13.37.5:/";
    where = "/mnt/dvb";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    requires = [ "wg-quick-wg-dvb.service" ];
    automountConfig = {
      TimeoutIdleSec = "600";
    };
    where = "/mnt/dvb";
  }];
}


