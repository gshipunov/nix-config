{ pkgs, lib, ... }:
{
  services.rpcbind.enable = true;

  systemd.mounts = {
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
    what = "10.13.37.5:/";
    where = "/mnt/dvb";
  };

  systemd.automounts = {
    wantedBy = [ "multi-user.target" ];
    automountConfig= {
      TimeoutIdleSec = "600";
    };
    where = "/mnt/dvb";
  };
}


