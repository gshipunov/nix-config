{ config, ... }:
{
  imports = [
    ./authentik.nix
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    appendHttpConfig = ''
      ### recommendedProxySettings minus proxy_redirect (breaks authentik)
      # proxy_redirect          off;
      proxy_connect_timeout   60s;
      proxy_send_timeout      60s;
      proxy_read_timeout      60s;
      proxy_http_version      1.1;
      proxy_set_header        "Connection" "";
      proxy_set_header        Host $host;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;
      proxy_set_header        X-Forwarded-Host $host;
      proxy_set_header        X-Forwarded-Server $host;

      ### TLS
      # Add HSTS header with preloading to HTTPS requests.
      # Adding this header to HTTP requests is discouraged
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      # Enable CSP for your services.
      add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      # Minimize information leaked to other domains
      add_header 'Referrer-Policy' 'origin-when-cross-origin';

      # Disable embedding as a frame
      add_header X-Frame-Options DENY;

      # Prevent injection of code in other mime types (XSS Attacks)
      add_header X-Content-Type-Options nosniff;
    '';
    # default vhost
    virtualHosts."oxapentane.com" = {
      forceSSL = true;
      enableACME = true;
      # default = true;
      locations."/" = {
        return = "200 '<html><body><h1>¯\\_(ツ)_/¯</h1></body></html>'";
        extraConfig = ''
          default_type text/html;
        '';

      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@oxapentane.com";
  };
}
