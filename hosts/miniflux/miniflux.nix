{ config, ... }:
{
  sops.secrets."miniflux" = { };

  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = config.sops.secrets."miniflux".path;
    config = {
      LISTEN_ADDR = "10.89.88.14:8080";
      BASE_URL = "https://news.oxapentane.com";
      # oauth
      DISABLE_LOCAL_AUTH = 1;
      CREATE_ADMIN = 0;
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.oxapentane.com/application/o/miniflux/";
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_REDIRECT_URL = "https://news.oxapentane.com/oauth2/oidc/callback";
      OAUTH2_USER_CREATION = 1;
      POLLING_FREQUENCY = 37;
    };
  };
}
