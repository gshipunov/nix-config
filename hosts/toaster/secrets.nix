{ config, ... }:
{
  sops.defaultSopsFile = ../../secrets/toaster/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    "wg/zw" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg/dvb" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg/mullvad" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg/0xa-mgmt" = {
      owner = config.users.users.systemd-network.name;
    };
  };
}
