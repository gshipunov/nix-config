{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    opensc

    yubioath-desktop
  ];

  # smartcard support
  services.pcscd.enable = false;
  hardware.gpgSmartcards.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
