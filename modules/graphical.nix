# General Desktop-related config
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox-wayland
    dino
    flameshot
    wl-clipboard
    pulseaudioFull
    screen-message
    qbittorrent
  ];

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
}
