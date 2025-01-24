{ ... }:
{
  services.nginx.virtualHosts."news.oxapentane.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://10.89.88.14:8080";
      extraConfig = ''
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
      '';
    };
  };
}
