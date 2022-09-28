{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    fd
    file
    fzf
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
    man-pages
    wlsunset
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  programs.tmux = {
    enable = true;
    keyMode = "vi";
    escapeTime = 0;
    historyLimit = 50000;
    aggressiveResize = true;
    terminal = "tmux-256color";
  };

  # set appropriate environ variables
  environment.variables = {
    EDITOR = "nvim";
    PAGER = "less -F";
  };

  environment.shellAliases = {
    ls = "ls --color=auto";
    l = "ls -l";
    la = "ls -la";
    ll = "ls -lah";
    lt = "ls --tree";
    vim = "nvim";
    vf = "$EDITOR $(fzf)";
    vff = "$EDITOR $(ls|fzf)";
    mutt = "neomutt";
    grep = "grep --color=auto";
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      bindkey -e
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
      LP_SSH_COLORS=1
    '';
  };

  programs.iftop.enable = true;
  programs.mosh.enable = true;
}
