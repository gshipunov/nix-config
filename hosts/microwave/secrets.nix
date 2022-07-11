{ config, ... }:
{
  sops.defaultSopsFile = ../../secrets/microwave/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    "wg/wg-zw-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg/wg-dvb-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg/mlwd-nl-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg/oxalab-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
  };
}
