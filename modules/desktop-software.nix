{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tdesktop
    fluffychat
    dino
    signal-desktop
    inkscape
    gimp
    blender
    kicad
    wl-clipboard
    firefox-wayland
    tor-browser-bundle-bin
    ffmpeg-full
  ];
}
