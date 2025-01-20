{ config, ... }:
{
  sops.secrets."radicale/htpasswd" = {
    owner = config.users.users.radicale.name;
  };
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "0.0.0.0:5232" "[::]:5232" ];
        ssl = "False";
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.sops.secrets."radicale/htpasswd".path;
      };
      rights = {
        type = "owner_only";
      };
    };
  };
}
