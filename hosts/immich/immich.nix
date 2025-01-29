{
  config,
  inputs,
  pkgs,
  ...
}:
let
  immich-latest = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.immich;
in
{
  sops.secrets."immich.yaml" = {
    sopsFile = ./immich.yaml;
    owner = config.services.immich.user;
    key = "";
  };

  services.immich = {
    enable = true;
    package = immich-latest;
    host = "10.89.88.13";
    redis.enable = true;
    database.createDB = true;
    settings = null; # has to contain secrets https://github.com/immich-app/immich/discussions/14815
    environment = {
      IMMICH_CONFIG_FILE = config.sops.secrets."immich.yaml".path;
    };
  };
}
