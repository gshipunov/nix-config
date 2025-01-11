{ config, ... }:
{
  sops.defaultSopsFile = ../../secrets/cloud/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    "wg/0xa-mgmt" = {
      owner = config.users.users.systemd-network.name;
    };
  };
}
