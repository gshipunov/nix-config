{ config, ... }: {
  sops.defaultSopsFile = ../../secrets/nextcloud/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."wg/oxaproxy-seckey" = {
    owner = config.users.users.systemd-network.name;
  };
  sops.secrets."nextcloud/adminpass" = {
    owner = config.users.users.nextcloud.name;
  };
}
