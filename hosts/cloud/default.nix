{ ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./proxy
    ./secrets.nix
  ];
}
