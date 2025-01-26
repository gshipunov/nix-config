{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = [
      pkgs.stdenv.cc.cc
    ];
  };
  #environment.variables = {
  #    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
  #      pkgs.stdenv.cc.cc
  #    ];
  #    #NIX_LD = "$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  #};
}
