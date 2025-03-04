{ config, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./proxy
  ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    "wg/0xa-mgmt" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg/0xa-proxy" = {
      owner = config.users.users.systemd-network.name;
    };
  };
}
