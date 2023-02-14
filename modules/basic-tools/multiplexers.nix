{ pkgs, inputs, ... }: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    escapeTime = 0;
    historyLimit = 500000;
    aggressiveResize = true;
    terminal = "tmux-256color";
    extraConfig = ''
      # all the colors we can get
      set-option -g default-terminal "tmux-256color"

      # emacs keys in status
      set -g status-keys emacs

      # set focus events
      set-option -g focus-events on

      # curlies
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      # title
      set -g set-titles on
      set -g set-titles-string "#T"

      # mouse
      set -g mouse on

      # theming
      #  modes
      setw -g clock-mode-colour white

      # panes
      set -g pane-border-style 'fg=colour244'
      set -g pane-active-border-style 'fg=colour03'

      #bind b break-pane -d

      # statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'bg=default fg=colour15'
      set -g status-right '[#S][@#H][%H:%M][%Y-%m-%d]'
      set -g status-left '(^_^)'
      #set -g status-right-length 50
      set -g status-left-length 40
      setw -g window-status-current-style 'fg=brightgreen bg=default bold'
      setw -g window-status-current-format ' #I#[fg=colour15]:#W#[fg=brightgreen]#F '
      setw -g window-status-style 'fg=gray bg=default'
      setw -g window-status-format ' #I#[fg=colour15]:#W#[fg=gray bold]#F '
      setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'

      # messages
      set -g message-style 'fg=black bg=white bold'

      # copy to clipboard support
      run-shell ${inputs.self.inputs.tmux-yank}/yank.tmux
    '';
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
