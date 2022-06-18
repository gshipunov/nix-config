{ config, ... }:
{
  sops.defaultSopsFile = ../../secrets/microwave/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    "wg/wg-zw-seckey" = { };
    "wg/wg-dvb-seckey" = { };
    "wg/mlwd-nl-seckey" = { };
    "wg/oxalab-seckey" = { };
  };
}
