{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    firefox-wayland
    dino
        feh
    mpv
    zathura
    brightnessctl
    alacritty
    pulsemixer
    cmus
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    xdg-utils

  ];

    services.acpid.enable = true;
  programs.light.enable = true;

  services.blueman.enable = true;

  services.xserver.enable = false;
  programs.xwayland.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      alacritty
      wofi
      waybar
      gnome3.adwaita-icon-theme
      i3status-rust
    ];
  };
  environment.sessionVariables = { GTK_THEME = "Adwaita:dark"; };
  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';
  xdg.portal.wlr.enable = true;

  services.udisks2.enable = true;
  environment.shellAliases = {
    mnt = "udisksctl mount -b";
    umnt = "udisksctl unmount -b";
    unlock = "udisksctl unlock -b";
    lock = "udisksctl lock -b";
  };

  qt5.platformTheme = "gnome";

}
