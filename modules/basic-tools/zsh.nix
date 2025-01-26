{ pkgs, ... }:
{
  environment.shellAliases = {
    ls = "ls --color=auto";
    l = "ls -l";
    la = "ls -la";
    ll = "ls -lah";
    lt = "ls --tree";
    vim = "nvim";
    grep = "grep --color=auto";
    e = "$EDITOR";
    v = "$EDITOR";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      bindkey -e
      export HISTFILE="$HOME/.zsh_history"
      export HISTSIZE=10000000
      export SAVEHIST=10000000
      setopt HIST_IGNORE_ALL_DUPS
      # allow comments
      setopt interactivecomments
    '';
    promptInit = ''
      source ${pkgs.liquidprompt}/share/zsh/plugins/liquidprompt/liquidprompt
    '';
  };

  environment.etc.liquidpromptrc = {
    text = ''
      LP_ENABLE_SSH_COLORS=1
      LP_ENABLE_TITLE=1
      LP_ENABLE_SCREEN_TITLE=1
      LP_ENABLE_TEMP=0
      LP_ENABLE_SVN=0
      LP_BATTERY_THRESHOLD=15
      LP_SSH_COLORS=1
    '';
  };
}
