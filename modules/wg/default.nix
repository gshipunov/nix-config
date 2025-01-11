{ ... }:
{
  imports = [
    # module
    ./module.nix
    ./options.nix
    # networks
    ./mgmt.nix
    ./proxy.nix
  ];
}
