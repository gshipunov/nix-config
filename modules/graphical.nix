# General Desktop-related config
{ config, pkgs, ... }:

{
  imports = [
    ./basic-tools.nix
    ./gnupg.nix
  ];

  environment.systemPackages = with pkgs; [
    firefox-wayland
    dino
    alacritty
    xclip
    flameshot
    wl-clipboard
    brightnessctl
    feh
    mpv
    zathura
    pulsemixer
    pulseaudioFull
    screen-message
    cmus
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    pamixer
    qbittorrent
    xdg-utils
  ];

  services.acpid.enable = true;
  programs.light.enable = true;

  #on the desktop, we need nice fonts ^^
  fonts.fonts = with pkgs; [
    dejavu_fonts
    julia-mono
    uw-ttyp0
    gohufont
    monoid
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
  sound.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio = {
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

  nix = {
    binaryCaches = [
      "https://dump-dvb.cachix.org"
    ];
    binaryCachePublicKeys = [
      "dump-dvb.cachix.org-1:+Dq7gqpQG4YlLA2X3xJsG1v3BrlUGGpVtUKWk0dTyUU="
    ];
  };
  programs.zsh.vteIntegration = true;
  programs.bash.vteIntegration = true;
  services.upower.enable = true;

  qt5.platformTheme = "gnome";
}
