{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    isync
    msmtp
    neomutt
    notmuch
    pass
    w3m
  ];

  programs.msmtp.enable = true;
}
