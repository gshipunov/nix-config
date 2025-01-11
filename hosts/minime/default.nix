{ ... }: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./secrets.nix
    ./zfs.nix
  ];
}
