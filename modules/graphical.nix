# General Desktop-related config
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox-wayland
    wl-clipboard
    pulseaudioFull
    screen-message
    qbittorrent
    dino
    imv
    mpv
    zathura
    brightnessctl
    pulsemixer
    cmus
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    xdg-utils
    nextcloud-client
    foot
    qt5.qtwayland
    bashmount
  ];

  #on the desktop, we need nice fonts ^^
  fonts.fonts = with pkgs; [
    monoid
    (nerdfonts.override { fonts = [ "Monoid" "Hack" "FiraMono" ]; })
    font-awesome
    dejavu_fonts
    julia-mono
    uw-ttyp0
    gohufont
    spleen
    terminus_font
    creep
    corefonts
    dina-font
    fira
    fira-mono
    hack-font
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    proggyfonts
    symbola
    open-sans
    twemoji-color-font
    twitter-color-emoji
  ];

  fonts.enableDefaultFonts = true;
  fonts.fontconfig = {
    enable = true;
    allowBitmaps = true;
    useEmbeddedBitmaps = true;
    defaultFonts.emoji = [
      "Twitter Color Emoji"
      "Noto Color Emoji"
    ];
  };

  # Enable sound.
  security.rtkit.enable = true;
  hardware.pulseaudio = {
    enable = false;
    zeroconf.discovery.enable = true;
    extraClientConf = ''
      autospawn=yes
    '';
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
  };

  programs.zsh.vteIntegration = true;
  programs.bash.vteIntegration = true;
  services.upower.enable = true;

  services.acpid.enable = true;
  programs.light.enable = true;

  services.blueman.enable = true;

  programs.xwayland.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export QT_QPA_PLATFORMTHEME="gnome"
      export QT_STYLE_OVERRIDE="adwaita-dark"
    '';
    extraPackages = with pkgs; [
      pamixer
      swaylock
      swayidle
      wl-clipboard
      mako
      foot
      rofi-wayland
      grim
      slurp
      waybar
      gnome3.adwaita-icon-theme
      i3status-rust
    ];
  };
  environment.sessionVariables = { GTK_THEME = "Adwaita:dark"; };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.udisks2.enable = true;
  environment.shellAliases = {
    mnt = "udisksctl mount -b";
    umnt = "udisksctl unmount -b";
    unlock = "udisksctl unlock -b";
    lock = "udisksctl lock -b";
  };

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.gnome.gnome-keyring.enable = true;

  # required to autounlock gnome-keyring
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
  programs.gnupg.agent.pinentryFlavor = "gnome3";
}
