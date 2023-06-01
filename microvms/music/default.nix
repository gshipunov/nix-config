{ pkgs, lib, config, ... }: {
  imports = [
    ./navidrome.nix
    ./oxaproxy.nix
    ./upload-user.nix
  ];

  microvm = {
    hypervisor = "qemu";
    mem = 4 * 1024;
    vcpu = 3;

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
      id = "vm-music";
      mac = "02:00:00:00:00:01";
    }];
  };

  networking = {
    hostName = "music";
  };

  system.stateVersion = "22.11";
}
