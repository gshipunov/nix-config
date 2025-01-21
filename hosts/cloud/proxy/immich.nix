{ ... }:
{
  services.nginx.upstreams.immich = {
    servers = {
      "10.89.88.13:2283" = { };
      "[fd31:185d:722f::13]:2283" = { };
    };
  };

  services.nginx.virtualHosts."immich.oxapentane.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://immich";
      extraConfig = ''
        client_max_body_size 50000M;

        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        send_timeout 600s;
      '';
    };
  };
}
