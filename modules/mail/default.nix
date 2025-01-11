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
    alot
    w3m
    links2
  ];

  environment.shellAliases = {
    mutt = "neomutt";
  };

  sops.secrets = {
    "mail/oxapentane.com" = {
      owner = config.users.users."0xa".name;
    };
    "mail/shipunov.xyz" = {
      owner = config.users.users."0xa".name;
    };
    "mail/dvb.solutions" = {
      owner = config.users.users."0xa".name;
    };
    "mail/tlm.solutions" = {
      owner = config.users.users."0xa".name;
    };
  };

  programs.msmtp = {
    enable = true;
    setSendmail = true;
    extraConfig = ''
      account mail@oxapentane.com
      host smtp.migadu.com
      port 587
      from *@oxapentane.com
      user mail@oxapentane.com
      passwordeval cat ${config.sops.secrets."mail/oxapentane.com".path}
      auth on
      tls on
      tls_trust_file	/etc/ssl/certs/ca-certificates.crt
      logfile ~/.msmtp.log

      account grigory@shipunov.xyz
      host smtp.migadu.com
      port 587
      from *@shipunov.xyz
      user grigory@shipunov.xyz
      passwordeval cat ${config.sops.secrets."mail/shipunov.xyz".path}
      auth on
      tls on
      tls_trust_file	/etc/ssl/certs/ca-certificates.crt
      logfile ~/.msmtp.log

      account dump@dvb.solutions
      host smtp.migadu.com
      port 587
      from dump@dvb.solutions
      user dump@dvb.solutions
      passwordeval cat ${config.sops.secrets."mail/dvb.solutions".path}
      auth on
      tls on
      tls_trust_file	/etc/ssl/certs/ca-certificates.crt
      logfile ~/.msmtp.log

      account grigory@tlm.solutions
      host smtp.migadu.com
      port 587
      from grigory@tlm.solutions
      user grigory@tlm.solutions
      passwordeval cat ${config.sops.secrets."mail/tlm.solutions".path}
      auth on
      tls on
      tls_trust_file	/etc/ssl/certs/ca-certificates.crt
      logfile ~/.msmtp.log
    '';
  };

  systemd.user = {

    # Service and timer to sync imap to local maildir
    services.mbsync = {
      enable = true;
      after = [
        "graphical.target"
        "network-online.target"
      ];
      script = ''
        ${pkgs.isync}/bin/mbsync -q -a --config=${mbsyncConf}
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
        OnBootSec = "5m";
        OnUnitInactiveSec = "11m";
      };
    };

    # service and timer to flush the msmtp queue
    services.flush-msmtpq = {
      enable = true;
      after = [
        "graphical.target"
        "network-online.target"
      ];
      script = ''
        ${pkgs.msmtp}/bin/msmtp-queue -r
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    timers.flush-msmtpq = {
      enable = true;
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "flush-msmtpq.service";
        OnBootSec = "11m";
        OnUnitInactiveSec = "13m";
      };
    };

  };
}
