{ ... }:

{
  powerManagement.cpuFreqGovernor = null;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      USB_BLACKLIST = "1d50:604b 1d50:6089 1d50:cc15 1fc9:000c";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      WIFI_PWR_ON_BAT = "off";
    };
  };
}
