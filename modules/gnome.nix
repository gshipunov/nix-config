{ config, pkgs, ... }: {

  imports = [
    ./desktop-software.nix
  ];
  environment.systemPackages = with pkgs; [
    amberol
    celluloid
    gnome-console
    gnome-obfuscate
    gnome.gnome-boxes
    gnome.gnome-tweaks
    nextcloud-client
    qbittorrent
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome.totem
    gnome.geary
    gnome.gnome-music
    gnome-console
  ];


  services.gnome = {
    evolution-data-server.enable = true;
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
  };

  programs = {
    seahorse.enable = true;
    gnupg.agent.pinentryFlavor = "gnome3";
    evolution = {
      enable = true;
      plugins = [ pkgs.evolution-ews ];
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
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

  programs.zsh.vteIntegration = true;
  programs.bash.vteIntegration = true;

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

  hardware.bluetooth.enable = true;

}
