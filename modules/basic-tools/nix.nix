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

  environment.shellAliases = {
    nix-build="${pkgs.nix-output-monitor}/bin/nom-build";
    nix-shell="${pkgs.nix-output-monitor}/bin/nom-shell";
  };

  programs.zsh.interactiveShellInit = ''
      # hacky wrapper for nix, so we can use nom automagically
      export _nom_cmd=${pkgs.nix-output-monitor}/bin/nom
      function nix {
          case $1 in
              build|shell|develop)
                  echo \[SUBSTITUTION\] ''$_nom_cmd ''${@:1} 1>&2
                  ''$_nom_cmd ''${@:1}
                  ;;
              *)
                  ${pkgs.nix}/bin/nix $@
          esac
      }
      compdef nix=_nix
  '';
}
