{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    celluloid
    gnome.gnome-boxes
    gnome.gnome-tweaks
    nextcloud-client
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome.totem
    gnome.geary

    gnome-console
    epiphany
  ];


  services.gnome = {
    evolution-data-server.enable = true;
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
    games.enable = true;
  };

  programs = {
    seahorse.enable = true;

  evolution = {
    enable = true;
    plugins = [ pkgs.evolution-ews ];
  };

  gnome-terminal.enable = true;
  };

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.gnupg.agent.pinentryFlavor = "gnome3";

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}
