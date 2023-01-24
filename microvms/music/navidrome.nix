{ config, ... }: {
  networking.firewall.interfaces.oxaproxy.allowedTCPPorts = [ 4533 ];
  services.navidrome = {
    enable = true;
    settings = {
      BaseUrl = "/";
      EnableExternalServices = false;
      MusicFolder = "/var/lib/music";
      Port = 4533;
      ScanSchedule = "@every 17min";
      TranscondigCacheSize = "5GiB";
    };
  };
}
