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
    nextcloud-client
  ];

  #on the desktop, we need nice fonts ^^
  fonts.fonts = with pkgs; [
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
    fira-code
    fira-code-symbols
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
    extraPackages = with pkgs; [
      swaylock-fancy
      swayidle
      wl-clipboard
      mako
      alacritty
      wofi
      wofi-emoji
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
  };

  services.udisks2.enable = true;
  environment.shellAliases = {
    mnt = "udisksctl mount -b";
    umnt = "udisksctl unmount -b";
    unlock = "udisksctl unlock -b";
    lock = "udisksctl lock -b";
  };

  qt5.platformTheme = "gtk";

  services.gnome.gnome-keyring.enable = true;

  programs.evolution = {
    enable = true;
    plugins = [ pkgs.evolution-ews ];
  };


  # required to autounlock gnome-keyring
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

}
