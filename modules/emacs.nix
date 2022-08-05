{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    direnv
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
    ]));
    defaultEditor = false;
  };

}
