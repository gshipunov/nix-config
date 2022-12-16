{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    opensc

    yubikey-personalization-gui
  ];

  # smartcard support
  services.pcscd.enable = false;
  hardware.gpgSmartcards.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
