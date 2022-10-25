{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    direnv
  ];

  nixpkgs.overlays = [
    inputs.emacs-overlay.overlay
  ];

  programs.zsh.shellInit = ''
    eval "$(direnv hook zsh)"
  '';
  programs.bash.shellInit = ''
    eval "$(direnv hook bash)"
  '';


  services.emacs = {
    install = true;
    enable = false;
    package = with pkgs; ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: with epkgs; [
      vterm
      pdf-tools
    ]));
    defaultEditor = false;
  };

}
