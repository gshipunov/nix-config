{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    exa
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
    tree
    liquidprompt
    (aspellWithDicts (ps: with ps; [ en en-science en-computers ru de ]))
    exfatprogs
    nmap
    bind
    nnn
    man-pages
  ];

  nix = {
    package = pkgs.nixUnstable;
    autoOptimiseStore = true;
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
    vim = "nvim";
    vi = "nvim";
    vf = "$EDITOR $(fzf)";
    vff = "$EDITOR $(ls|fzf)";
    ssh = "TERM=xterm-256color ssh";
    mutt = "neomutt";
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
            source /run/current-system/sw/share/zsh/plugins/liquidprompt/liquidprompt
      if [[ -n "$IN_NIX_SHELL" ]]; then
        prompt_tag "(nix-shell)"
      fi
    '';
  };

  environment.etc.liquidpromptrc = {
    text = ''
      LP_ENABLE_SSH_COLORS=1
      LP_ENABLE_TITLE=1
      LP_ENABLE_SCREEN_TITLE=1
    '';
  };

  programs.iftop.enable = true;
  programs.mosh.enable = true;
}
