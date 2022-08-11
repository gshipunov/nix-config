{ config, pkgs, ... }:
let
  mbsyncConf = ./mbsyncrc;
in
{
  environment.systemPackages = with pkgs; [
    isync
    msmtp
    neomutt
    notmuch
    pass
    w3m
  ];

  sops.secrets = {
    "mail/oxapentane.com" = {
      owner = config.users.users.grue.name;
    };
    "mail/shipunov.xyz" = {
      owner = config.users.users.grue.name;
    };
    "mail/dvb.solutions" = {
      owner = config.users.users.grue.name;
    };
  };

  programs.msmtp = {
    enable = true;
    setSendmail = true;
  };
  systemd.user = {

    services.mbsync = {
      enable = true;
      after = [ "graphical.target" "network-online.target" ];
      script = ''
        ${pkgs.isync}/bin/mbsync -a --config=${mbsyncConf}
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    timers.mbsync = {
      enable = true;
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "mbsync.service";
        OnUnitInactiveSec = "11m";
        Persistent = true;
      };
    };

  };
}
