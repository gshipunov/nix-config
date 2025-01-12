{ config, ... }:
{
  services.authentik = {
    enable = true;
    environmentFile = config.sops.secrets."authentik/envfile".path;
    settings.disable_startup_analytics = true;
  };
}
