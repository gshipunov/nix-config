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

  services.nginx.virtualHosts."nc.oxapentane.com" = {
    enableACME = true;
    forceSSL = true;
    extraConfig = ''
      client_max_body_size 512M;
    '';
    locations = {
      "/" = {
        #  extraConfig = '' return 503; '';
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
}