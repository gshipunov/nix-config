{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    blender
    dino
    ffmpeg-full
    firefox-wayland
    gimp
    inkscape
    kicad
    signal-desktop
    tdesktop
    tor-browser-bundle-bin
    wl-clipboard
    yt-dlp
    element-desktop
    discord
    spotify
  ];
  programs.steam.enable = true;
}
