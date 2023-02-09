{ pkgs, config, ... }: {
  services.nginx = {
    # reverse-proxy irc traffic on 7000
    streamConfig = ''
      upstream soju {
        server 127.0.0.1:6667;
      }

      server {
        listen 7000 ssl;
        listen [::]:7000 ssl;

        ssl_certificate /var/lib/acme/mrbouncy.oxapentane.com/fullchain.pem;
        ssl_certificate_key /var/lib/acme/mrbouncy.oxapentane.com/key.pem;
        ssl_trusted_certificate /var/lib/acme/mrbouncy.oxapentane.com/chain.pem;

        proxy_pass soju;
      }
    '';
    # just here to get the cert for irc reverse proxy
    virtualHosts = {
      "mrbouncy.oxapentane.com" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            # no content for now, here just for no-boilerplate cert
            return = "204";
          };
        };
      };
    };
  };

  services.soju = {
    hostName = "mrbouncy.oxapentane.com";
    listen = [ "irc+insecure://127.0.0.1:6667" ];
    enable = true;
    enableMessageLogging = true;
    acceptProxyIP = [ "localhost" ];
  };

  environment.systemPackages = [ pkgs.soju ]; # expose soju mgmt commands

  networking.firewall.allowedTCPPorts = [ 7000 ];
}
