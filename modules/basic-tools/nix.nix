{ lib, pkgs, inputs, ... }: {

  nix = {
    extraOptions = ''
    experimental-features = nix-command flakes
    narinfo-cache-negative-ttl = 0
    '';
  };

  # nix output-monitor
  environment.systemPackages = [ pkgs.nix-output-monitor ];

  # override default nix shell nixpkgs# behaviour to use current flake lock
  nix.registry =
    let flakes = lib.filterAttrs (_name: value: value ? outputs) inputs.self.inputs;
    in builtins.mapAttrs (_name: v: { flake = v; }) flakes;

  nix.nixPath = lib.mapAttrsToList (name: value: "${name}=${value.outPath}") inputs.self.inputs;
}
