{ config, pkgs, ... }:
{

  imports = [
    ./desktop-software.nix
  ];
  environment.systemPackages = with pkgs; [
    amberol
    celluloid
    gnome-console
    gnome-obfuscate
    gnome-boxes
    gnome-tweaks
    qbittorrent
    gnomeExtensions.caffeine
  ];

  environment.gnome.excludePackages = with pkgs; [
    totem
    geary
    gnome-music
  ];

  services.gnome = {
    evolution-data-server.enable = true;
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
  };

  programs = {
    seahorse.enable = true;
    gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
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
  services.pulseaudio = {
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
    iosevka-bin
    nerd-fonts.hack
  ];

  fonts.enableDefaultPackages = true;
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
