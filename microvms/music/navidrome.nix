{ config, ... }: {
  networking.firewall.interfaces.oxaproxy.allowedTCPPorts = [ 4533 ];
  services.navidrome = {
    enable = true;
    settings = {
      Address = "10.34.45.101";
      BaseUrl = "/";
      EnableExternalServices = false;
      MusicFolder = "/var/lib/music";
      Port = 4533;
      ScanSchedule = "@every 11m";
      TranscondigCacheSize = "5GiB";
      ReverseProxyWhitelist = "10.34.45.1/24";
    };
  };
}
