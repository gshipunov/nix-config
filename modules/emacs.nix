{ pkgs, inputs, ... }:

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
    package = with pkgs; ((emacsPackagesFor emacsPgtk).emacsWithPackages (epkgs: with epkgs; [
      vterm
    ]));
    defaultEditor = false;
  };

}
