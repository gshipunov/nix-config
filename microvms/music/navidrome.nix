{ config, ... }: {
  services.navidrome = {
    enable = true;
    settings = {
      BaseUrl = "/";
      EnableExternalServices = false;
      MusicFolder = "/var/lib/navidrome/library";
      ScanSchedule = "@every 17min";
      TranscondigCacheSize = "5GiB";
    };
  };
}
