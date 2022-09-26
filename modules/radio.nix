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
  ];

  hardware = {
    rtl-sdr.enable = true;
    hackrf.enable = true;
  };
}
