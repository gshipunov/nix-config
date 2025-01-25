{ ... }:
{
  services.nginx.upstreams.authentik = {
    servers = {
      "10.89.88.11:9000" = { };
      "[fd31:185d:722f::11]:9000" = { };
    };
    extraConfig = ''
      keepalive 10;
    '';
  };

  services.nginx.virtualHosts."auth.oxapentane.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://authentik";
      extraConfig = ''
        # general proxy settings
        proxy_connect_timeout   60s;
        proxy_send_timeout      60s;
        proxy_read_timeout      60s;
        proxy_http_version      1.1;
        proxy_set_header        Host $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;
        proxy_set_header        X-Forwarded-Host $host;
        proxy_set_header        X-Forwarded-Server $host;
        # authentik specifik
        proxy_set_header        Upgrade $http_upgrade;
        proxy_set_header        Connection $connection_upgrade_keepalive;
      '';
    };
  };
}
