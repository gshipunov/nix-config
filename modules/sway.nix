# General Desktop-related config
{ pkgs, ... }:
{
  imports = [
    ./desktop-software.nix
  ];
  environment.systemPackages = with pkgs; [
    screen-message
    qbittorrent
    gajim
    imv
    swayimg
    mpv
    evince
    brightnessctl
    pulsemixer
    cmus
    termusic
    gsettings-desktop-schemas
    xdg-utils
    foot
    qt5.qtwayland
    bashmount
    nautilus
    audacity
  ];

  #on the desktop, we need nice fonts ^^
  fonts.packages = with pkgs; [
    monoid
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
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-extra
    proggyfonts
    symbola
    open-sans
    twemoji-color-font
    twitter-color-emoji
    iosevka
    nerd-fonts.hack
  ];

  fonts.enableDefaultPackages = true;
  fonts.fontconfig = {
    enable = true;
    allowBitmaps = true;
    useEmbeddedBitmaps = true;
    defaultFonts.emoji = [
      "Noto Color Emoji"
      "Twitter Color Emoji"
    ];
  };

  # Enable sound.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
  };

  programs.zsh.vteIntegration = true;
  programs.bash.vteIntegration = true;
  services.upower.enable = true;

  services.acpid.enable = true;
  programs.light.enable = true;

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
      # export WLR_DRM_NO_ATOMIC=1
    '';
    extraPackages = with pkgs; [
      adwaita-icon-theme
      alacritty
      bluetui
      foot
      gammastep
      graphicsmagick
      grim
      i3status-rust
      impala
      kanshi
      mako
      pamixer
      rofi-wayland
      slurp
      swayidle
      swaylock
      wl-clipboard
      wl-mirror
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
    # mounting shit
    mnt = "udisksctl mount -b";
    umnt = "udisksctl unmount -b";
    unlock = "udisksctl unlock -b";
    lock = "udisksctl lock -b";
    # easier navigation
    pwc = "pwd|wl-copy";
    cdp = "cd $(wl-paste)";
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --greeting \"$(${pkgs.fortune}/bin/fortune -s)\" --cmd ${pkgs.sway}/bin/sway";
      };
    };
  };

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;
  programs.ssh = {
    startAgent = true;
    enableAskPassword = false;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
