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
    tor-browser
    wl-clipboard
    yt-dlp
    element-desktop
    discord
    spotify
    mpv
  ];
  programs.steam.enable = true;
}
