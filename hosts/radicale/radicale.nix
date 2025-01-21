{ config, ... }:
{
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "0.0.0.0:5232" "[::]:5232" ];
        ssl = "False";
      };
      auth = {
        type = "http_x_remote_user";
      };
      rights = {
        type = "owner_only";
      };
    };
  };
}
