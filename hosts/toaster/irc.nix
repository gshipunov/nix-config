{ config, pkgs, ... }: {
  environment.systemPackages = [ pkgs.senpai ];

  sops.secrets = {
    "irc/senpai" = {
      owner = config.users.users.grue.name;
    };
  };
}
