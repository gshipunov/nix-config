{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnuradio
    gqrx
    cubicsdr
    sdrangel
    multimon-ng
    sox

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

  services.udev.extraRules = ''
    # MCH2022 Badge
    SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="0f9a", MODE="0666"

    #Flipper Zero serial port
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
    #Flipper Zero DFU
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess"
    #Flipper ESP32s2 BlackMagic
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="40??", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
  '';

}
