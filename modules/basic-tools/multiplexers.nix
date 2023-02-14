{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    escapeTime = 0;
    historyLimit = 500000;
    aggressiveResize = true;
    terminal = "tmux-256color";
  };

  programs.zsh.interactiveShellInit = ''
    # create new tmux session with $1 as a name
    # if no arguments supplied, use name of current dir

    function tn {
        if [ $# -eq 0 ]
        then
            tmux new-session -s $(basename $(pwd))
        else
            tmux new-session -s $1
        fi
    }
  '';

  environment.shellAliases = {
    tl = "tmux list-sessions";
    ta = "tmux attach -t";
  };

  environment.systemPackages = [
    pkgs.screen
  ];

  programs.screen.screenrc = ''
    defscrollback 10000

    startup_message off

    hardstatus on
    hardstatus alwayslastline
    hardstatus string "%w"
  '';
}
