{ config, pkgs, ... }: {

  imports = [
    ./oxaproxy.nix
    ./secrets.nix
  ];

  # nextcloud goes here
  networking.firewall.interfaces.oxaproxy.allowedTCPPorts = [ 8080 ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [{
      name = "nextcloud";
      ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
    }];
  };

  services.redis.servers.nextcloud.enable = true;

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    virtualHosts."nc.oxapentane.com" = {
      extraConfig = ''
        # HTTP response headers borrowed from Nextcloud .htaccess
        add_header Referrer-Policy                      "no-referrer"   always;
        #add_header X-Content-Type-Options               "nosniff"       always;
        add_header X-Download-Options                   "noopen"        always;
        #add_header X-Frame-Options                      "SAMEORIGIN"    always;
        add_header X-Permitted-Cross-Domain-Policies    "none"          always;
        add_header X-Robots-Tag                         "none"          always;
        add_header X-XSS-Protection                     "1; mode=block" always;
        add_header Strict-Transport-Security            "max-age=31536000; includeSubDomains" always;

        # Remove X-Powered-By, which is an information leak
        fastcgi_hide_header X-Powered-By;
      '';
      listen = [{
        # We are listening on wireguard interface only
        addr = "10.34.45.100";
        port = 8080;
        ssl = false;
      }];
    };
  };

  services.nextcloud = {
    enable = true;
    hostName = "nc.oxapentane.com";
    home = "/var/lib/nextcloud-oxa";
    package = pkgs.nextcloud26;
    maxUploadSize = "5000M";
    caching.redis = true;
    autoUpdateApps = {
      enable = true;
      startAt = "07:00:00";
    };
    config = {
      overwriteProtocol = "https";
      trustedProxies = [ "10.34.45.1" ];

      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      adminuser = "admin";
      adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
    };
  };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };




  microvm = {
    hypervisor = "qemu";
    mem = 4 * 1024;
    vcpu = 3;

    shares = [{
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "store";
      proto = "virtiofs";
      socket = "store.socket";
    }] ++ map
      (dir: {
        source = "/var/lib/microvms/${config.networking.hostName}/${dir}";
        mountPoint = "/${dir}";
        tag = dir;
        proto = "virtiofs";
        socket = "${dir}.socket";
      }) [ "etc" "var" "home" ];

    interfaces = [{
      type = "tap";
      id = "vm-nextcloud";
      mac = "02:00:00:00:00:00";
    }];
  };

  networking = {
    hostName = "nextcloud";
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDP6xE2ey0C8XXfvniiiHiqXsCC277jKI9RXEA+s2LQLUI5zl7v350i3Oa8H3NCcPj39lfMreqE6ncxcOhqYyzahPrrMkOqgbPAoRvq8H3ophLK+56O3xdHoKwLBwRD1yoGACjqG4UTiTrmnN2ateENgYcnTEY1e4vDw1qMj1drUXCsZ/6mkBBmHJiFfCaR4yCMt1r4gGi/dAC7ifnBP3oSyV/lJEwPxYYkGlbOBIvX/7Ar98pJS6xYPB3jHs9gwyNNON63d0fNYrwBojXPPCnGGaRZNOkBTzex3zZYp12ThINQ2xl8tRp9D8qpZ7vrLjhTD6AXkOBRzmDj+NsCeEaeTuWajqUM93iKncYUI+JxR1t7q8gA2pBMFzLesMXnx7R+5Kw7QDtSJM7a4GMIfsocPwf64BH6rzxEz68rXFE3P+J77PPM9CuaYw90JXHo3z220zYw2nMQ/1qjATVZw/hiVrLmQMVfmFJIufnGjTBs2sy3IoNyzvYm/oDeNNg1cdSV9gyyRKZhK08fxjXN5GSf9vZkfZa9tHtqaZ99HI40GQBHUVx1K2/NQJY8TVTSA+v16SFnJK8BIbmp/WFCuvDcMkgLIbqiYtDASe7P2mKIib86uOENT+P820egeLiTQ06kFw/gfUa8t69d5qEcjiQZ+lxCeYIs/E9KrEXHvRUWew== cardno:16 811 348"
  ];

  system.stateVersion = "22.05";
}
