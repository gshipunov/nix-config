
{ config, lib, ... }:
let
  mac = "02:00:00:00:00:03";
in
{
  imports = [
    ./immich.nix
  ];
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    "wg/0xa-proxy" = {
      owner = config.users.users.systemd-network.name;
    };
  };

  microvm = {
    hypervisor = "qemu";
    mem = 4 * 1024;
    vcpu = 2;
    interfaces = [
      {
        type = "tap";
        id = "uvm-immich";
        mac = mac;
      }
    ];
    shares =
      [
        {
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "store";
          proto = "virtiofs";
          socket = "store.socket";
        }
      ]
      ++ map
        (dir: {
          source = dir;
          mountPoint = "/${dir}";
          tag = dir;
          proto = "virtiofs";
          socket = "${dir}.socket";
        })
        [
          "etc"
          "var"
          "home"
        ];
  };

  networking.useNetworkd = true;
  networking.firewall.enable = lib.mkForce false; # firewalling done by the host

  systemd.network = {
    enable = true;
    networks."11-host" = {
      matchConfig.MACAddress = mac;
      networkConfig = {
        Address = "10.99.99.13/24";
        DHCP = "no";
      };
      routes = [
        {
          Gateway = "10.99.99.1";
          Destination = "0.0.0.0/0";
          Metric = 1024;
        }
      ];
    };
  };

  networking.hostName = "immich";
  system.stateVersion = "24.11";
}
