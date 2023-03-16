# General Desktop-related config
{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox-wayland
    wl-clipboard
    screen-message
    qbittorrent
    dino
    tdesktop
    # (tdesktop.overrideAttrs (old: rec {
    #   version = "4.6.7";
    #   src = fetchFromGitHub {
    #     owner = "forkgram";
    #     repo = "tdesktop";
    #     rev = "v${version}";
    #     sha256 = "sha256-KMV/t3AC/kZQVz31UPYEKU/An6ycdsabZazUVCA9yIU=";
    #   };
    # }))
    signal-desktop
    gajim
    imv
    swayimg
    mpv
    zathura
    brightnessctl
    pulsemixer
    cmus
    termusic
    gsettings-desktop-schemas
    xdg-utils
    nextcloud-client
    foot
    qt5.qtwayland
    bashmount
    (xfce.thunar.override { thunarPlugins = with xfce; [ thunar-volman thunar-archive-plugin ]; })
    audacity
    yt-dlp
    tor-browser-bundle-bin
    ffmpeg-full
    gimp
    inkscape
    blender
  ];

  #on the desktop, we need nice fonts ^^
  fonts.fonts = with pkgs; [
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
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    proggyfonts
    symbola
    open-sans
    twemoji-color-font
    twitter-color-emoji
    iosevka
  ];

  fonts.enableDefaultFonts = true;
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

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    config.pipewire-pulse =
      let default-pipewire-pulse = lib.importJSON (pkgs.path + "/nixos/modules/services/desktops/pipewire/daemon/pipewire-pulse.conf.json");
      in
      default-pipewire-pulse // {
        "context.modules" = default-pipewire-pulse."context.modules" ++ [
          {
            "name" = "libpipewire-module-zeroconf-discover";
          }
        ];
      };
  };
  hardware.pulseaudio.zeroconf.discovery.enable = true;

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
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
      alacritty
      pamixer
      swaylock
      graphicsmagick
      swayidle
      wl-clipboard
      mako
      foot
      rofi-wayland
      grim
      slurp
      gnome.adwaita-icon-theme
      i3status-rust
      wlsunset
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
