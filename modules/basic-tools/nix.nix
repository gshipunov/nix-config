{ lib, pkgs, inputs, ... }: {

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # override default nix shell nixpkgs# behaviour to use current flake lock
  nix.registry =
    let flakes = lib.filterAttrs (_name: value: value ? outputs) inputs.self.inputs;
    in builtins.mapAttrs (_name: v: { flake = v; }) flakes;

  nix.nixPath = lib.mapAttrsToList (name: value: "${name}=${value.outPath}") inputs.self.inputs;
}
