{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    ./fzf.nix
    ./multiplexers.nix
    ./nix.nix
  ];

  environment.systemPackages = with pkgs; [
    bat
    fd
    file
    git
    gnupg
    htop
    irssi
    killall
    neovim
    ripgrep
    tealdeer
    traceroute
    tcpdump
    tree
    (aspellWithDicts (ps: with ps; [ en en-science en-computers ru de ]))
    exfatprogs
    nmap
    bind
    nnn
    ranger
    man-pages
    unzip
    usbutils
    pciutils
    ouch
  ];

  # set appropriate environ variables
  environment.variables = {
    EDITOR = "nvim";
    PAGER = "less";
    LESS = "-X -R -F";
  };

  environment.shellAliases = {
    ls = "ls --color=auto";
    l = "ls -l";
    la = "ls -la";
    ll = "ls -lah";
    lt = "ls --tree";
    vim = "nvim";
    grep = "grep --color=auto";
  };

  users.defaultUserShell = pkgs.zsh;
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

  programs.iftop.enable = true;
  programs.mosh.enable = true;

}
