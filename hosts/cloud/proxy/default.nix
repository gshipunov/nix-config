{ config, ... }:
{
  imports = [
    ./auth.nix
    ./dav.nix
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    appendHttpConfig = ''
      # upgrade websockets
      map $http_upgrade $connection_upgrade_keepalive {
        default upgrade;
        '''      ''';
      }

      ### TLS
      # Add HSTS header with preloading to HTTPS requests.
      # Adding this header to HTTP requests is discouraged
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      # Enable CSP for your services.
      # add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      # Minimize information leaked to other domains
      add_header 'Referrer-Policy' 'origin-when-cross-origin';

      # Disable embedding as a frame
      # add_header X-Frame-Options DENY;

      # Prevent injection of code in other mime types (XSS Attacks)
      add_header X-Content-Type-Options nosniff;
    '';
    # default vhost
    virtualHosts."oxapentane.com" = {
      forceSSL = true;
      enableACME = true;
      # default = true;
      locations."/" = {
        return = "503";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@oxapentane.com";
  };
}
