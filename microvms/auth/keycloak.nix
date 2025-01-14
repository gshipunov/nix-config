{ config, ... }:
{
  services.keycloak = {
    enable = true;
    database = {
      type = "postgresql";
      createLocally = true;
      passwordFile = config.sops.secrets."keycloak/db_pass".path;
    };
    settings = {
      hostname = "https://auth.oxapentane.com";
      http-port = 38080;
      http-enabled = true;
      proxy-headers = "xforwarded";
      proxy-trusted-addresses = "10.89.88.0/24,fd31:185d:722f::/48";
    };
  };
}
