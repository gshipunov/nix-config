{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lsd
    fzf
    grc
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.tide
    fishPlugins.grc
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      ls = "lsd --icon=never";
      l = "ls -l";
      ll = "ls -la";
      vim = "nvim";
      grep = "grep --color=auto";
    };
  };
}
