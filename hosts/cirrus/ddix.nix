{ config, ... }: {
  services.nginx.virtualHosts = {
    "dd-ix.net" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        extraConfig = ''
          return 307 https://c3d2.de;
        '';
      };
    };
    "www.dd-ix.net" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        extraConfig = ''
          return 307 https://c3d2.de;
        '';
      };
    };
  };
}
