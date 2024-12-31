{ pkgs, inputs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    direnv
  ];

  nixpkgs.overlays = [
    inputs.emacs-overlay.overlay
  ];

  services.emacs = {
    install = true;
    enable = false;
    package = with pkgs; ((emacsPackagesFor (emacs-pgtk.overrideAttrs (old: {
      passthru = old.passthru // {
        treeSitter = true;
      };
    }))).emacsWithPackages (epkgs: with epkgs; [
      # treesitter bits
      treesit-grammars.with-all-grammars

      vterm
      pdf-tools
    ]));
    defaultEditor = lib.mkDefault true;
  };

}
