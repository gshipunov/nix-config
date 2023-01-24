{ config, ... }: {
  networking.firewall.interfaces.oxaproxy.allowedTCPPorts = [ 4533 ];
  services.navidrome = {
    enable = true;
    settings = {
      BaseUrl = "/";
      EnableExternalServices = false;
      MusicFolder = "/var/lib/navidrome/library";
      Port = 4533;
      ScanSchedule = "@every 17min";
      TranscondigCacheSize = "5GiB";
    };
  };
}
