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
    defaults = {
        tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
        logfile = "/tmp/msmtp.log";
    };
    accounts = {
      "mail@oxapentane.com" = {
        host = "smtp.migadu.com";
        port = 578;
        from = "*@oxapentane.com";
        user = "mail@oxapentane.com";
        passwordeval = "cat ${config.sops.secrets."mail/oxapentane.com".path}";
        auth = "on";
        tls = "on";
      };
      "grigory@shipunov.xyz" = {
        host = "smtp.migadu.com";
        port = 578;
        from = "*@shipunov.xyz";
        user = "mail@oxapentane.com";
        passwordeval = "cat ${config.sops.secrets."mail/shipunov.xyz".path}";
        auth = "on";
        tls = "on";
      };
      "dump@dvb.solutions" = {
        host = "smtp.migadu.com";
        port = 578;
        from = "dump@dvb.solutions";
        user = "dump@dvb.solutions";
        passwordeval = "cat ${config.sops.secrets."mail/dvb.solutions".path}";
        auth = "on";
        tls = "on";
      };
    };
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
