{ config, pkgs, ... }: {
  security.acme = {
    defaults.email = "acme@oxapentane.com";
    acceptTerms = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
  };

  services.nginx.virtualHosts = {
    "nc.oxapentane.com" = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
      client_max_body_size 512M;
      '';
      locations = {
        "/" = {
        proxyPass = "http://10.34.45.100:8080";
      };
      "/well-known/carddav" = {
        return = "301 $scheme://$host/remote.php/dav";
      };
      "/well-known/caldav" = {
        return = "301 $scheme://$host/remote.php/dav";
      };
    };
  };

  "music.oxapentane.com" = {
    enableACME = true;
    forceSSL = true;
    extraConfig = ''
    client_max_body_size 32M;
    '';
    locations = {
      "/" = {
        proxyPass = "http://10.34.45.101:4533";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Protocol $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
          proxy_buffering off;
        '';
      };
    };
  };
};
}
