{ config, ... }:
{
  sops.secrets."authentik/env" = {};
  services.authentik = {
    enable = true;
    environmentFile = config.sops.secrets."authentik/env".path;
    settings = {
      log_level = "debug";
      disable_startup_analytics = true;
      avatars = "initials";
    };
  };
}
