{ pkgs, ... }:
{

  imports = [
    ./desktop-software.nix
    ./fonts.nix
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
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  programs.zsh.vteIntegration = true;
  programs.bash.vteIntegration = true;

  hardware.bluetooth.enable = true;

}
