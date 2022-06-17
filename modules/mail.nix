{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    neomutt
  ];

  programs.msmtp.enable = true;
}
