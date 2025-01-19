{ config, ... }:
{
  sops.secrets."oauth2-proxy/env" = {
    owner = config.users.users.oauth2-proxy.name;
  };

  services.oauth2-proxy = {
    enable = true;
    reverseProxy = true;
    provider = "keycloak-oidc";
    httpAddress = "0.0.0.0:4180";
    oidcIssuerUrl = "https://auth.oxapentane.com/realms/0xalab-prod";
    clientID = "radicale-proxy";
    redirectURL = "https://dav.oxapentane.com/oauth2/callback";
    keyFile = config.sops.secrets."oauth2-proxy/env".path;
    scope = "openid";
    email.domains = [ "*" ];
    setXauthrequest = true;
    cookie = {
      secure = true;
      refresh = "48h0m0s";
      domain = ".oxapentane.com";
    };
  };
}
