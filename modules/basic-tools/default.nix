{ pkgs, config, ... }:

{
  imports = [
    ./fzf.nix
    ./multiplexers.nix
    ./nix.nix
    ./nix-ld.nix
    ./zsh.nix
    ./fish.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
      bat
      fd
      file
      gnupg
      glow
      htop
      irssi
      killall
      neovim
      ripgrep
      tealdeer
      traceroute
      tcpdump
      tree
      (aspellWithDicts (
        ps: with ps; [
          en
          en-science
          en-computers
          ru
          nl
        ]
      ))
      exfatprogs
      nmap
      bind
      nnn
      lf
      man-pages
      unzip
      usbutils
      pciutils
      ouch
      cryptsetup
      sshfs
      whois
      mtr
    ]
    ++ (if config.networking.hostName == "toaster" then [ gitFull ] else [ git ]);

  environment.variables =
    let
      editorconf =
        if config.services.emacs.defaultEditor then
          { }
        else
          {
            EDITOR = "nvim";
          };
    in
    {
      PAGER = "less";
      LESS = "-X -R -F";
    }
    // editorconf;

  environment.shellAliases = {
    vim = "nvim";
    grep = "grep --color=auto";
  };
  users.defaultUserShell = pkgs.zsh; # keep root shell posix compatible

  programs.iftop.enable = true;
  programs.mosh.enable = true;

}
