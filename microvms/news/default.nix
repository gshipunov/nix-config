{ config, ... }: {
  imports = [
    ./miniflux.nix
    ./oxaproxy.nix
  ];

  microvm = {
    hypervisor = "qemu";
    mem = 1 * 1024;
    vcpu = 1;

    shares = [{
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "store";
      proto = "virtiofs";
      socket = "store.socket";
    }] ++ map
      (dir: {
        source = "/var/lib/microvms/${config.networking.hostName}/${dir}";
        mountPoint = "/${dir}";
        tag = dir;
        proto = "virtiofs";
        socket = "${dir}.socket";
      }) [ "etc" "var" "home" ];

    interfaces = [{
      type = "tap";
      id = "vm-news";
      mac = "02:00:00:00:00:02";
    }];
  };

  networking = {
    hostName = "news";
  };

  system.stateVersion = "22.11";
}
