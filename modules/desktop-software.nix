{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    blender
    dino
    ffmpeg-full
    firefox-wayland
    fluffychat
    gimp
    inkscape
    kicad
    signal-desktop
    tdesktop
    tor-browser-bundle-bin
    wl-clipboard
    yt-dlp
  ];
}
