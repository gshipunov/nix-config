{ config, ... }: {
  networking.firewall.interfaces.oxaproxy.allowedTCPPorts = [ 4533 ];
  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      BaseUrl = "/";
      EnableExternalServices = false;
      MusicFolder = "/var/lib/music";
      Port = 4533;
      ScanSchedule = "@every 11m";
      TranscondigCacheSize = "5GiB";
    };
  };
}
