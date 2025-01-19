{ ... }:
{
  services.nginx.upstreams.keycloak = {
    servers = {
      "10.89.88.11:38080" = { };
      "[fd31:185d:722f::11]:38080" = { };
    };
  };

  services.nginx.virtualHosts."auth.oxapentane.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://keycloak";
      extraConfig = ''
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port 433;
      '';
    };
  };
}
