{ config, ... }:
{
  sops.defaultSopsFile = ../../secrets/dishwasher/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    "wg/oxalab-seckey" = { };
  };
}
