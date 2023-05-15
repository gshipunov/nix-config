{ config, ... }:
let
  listenport = 8080;
in
  {
    sops.secrets."miniflux-admin" = { };

  networking.firewall.interfaces.oxaproxy.allowedTCPPorts = [ listenport ];
  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "10.34.45.102:${toString listenport}";
      POLLING_FREQUENCY = "37";
      CREATE_ADMIN = "1";
    };
    adminCredentialsFile = config.sops.secrets."miniflux-admin".path;
  };
}
