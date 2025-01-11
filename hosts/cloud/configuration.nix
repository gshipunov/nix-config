{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "cloud";
  networking.domain = "oxapentane.com";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJl9iYG5oHBq/poBn7Jf1/FGWWbAnbx+NKjs7qtT3uAK''
  ];
  system.stateVersion = "24.11";
}
