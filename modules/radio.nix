{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnuradio
    gqrx
    cubicsdr

    libusb1
    rtl-sdr
    hackrf
    soapyhackrf

    sigdigger
    suscan
    sigutils
  ];

  hardware = {
    rtl-sdr.enable = true;
    hackrf.enable = true;
  };
}
