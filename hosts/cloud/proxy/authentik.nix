# TODO: integrade with oxalab-wg
{ config, ... }:
{
  # authentik
  services.nginx.upstreams.authentik = {
    extraConfig = ''
          keepalive 10;
    '';
    servers =
      {
        "10.89.88.2:9000" = { };
        "[fd31:185d:722f::2]:9000" = { };
      };
    };

    services.nginx.virtualHosts."sso.oxapentane.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://authentik";
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        '';
      };
    };
  }
