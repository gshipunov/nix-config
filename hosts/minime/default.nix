{ ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./networking
    ./secrets.nix
    ./zfs.nix
  ];
}
