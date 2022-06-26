{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./secrets.nix
    ./wireguard-server.nix
    ./nextcloud-proxy.nix
  ];
}
