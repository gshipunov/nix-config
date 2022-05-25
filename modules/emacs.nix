{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # language servers
    clang-tools
    clang

    sqlite
    graphviz
  ];

  services.emacs = {
    install = true;
    enable = false;
    # pure gtk, native compiled emacs with vterm and pdf-tools
    package = with pkgs; ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]));
    defaultEditor = false;
  };

}
