{ ... }:
{
  nix = {
    extraOptions = ''
      builders-use-substitutes = true
    '';

    settings = {
      trusted-users = [
        "0xa"
        "@wheel"
      ];
      substituters = [
        "https://microvm.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-substituters = [
        "https://microvm.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
