{ config, pkgs, ... }:

{
  powerManagement.cpuFreqGovernor = null;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.tlp.extraConfig = ''
USB_BLACKLIST="1d50:604b 1d50:6089 1d50:cc15 1fc9:000c"
'';
}
