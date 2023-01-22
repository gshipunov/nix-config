{ pkgs, config, ... }: {
  containers.irc = {
    autoStart = true;
    privateNetwork = true;
    config = { config, pkgs, ... }: {
      services.soju = {
        enable = true;
        enableMessageLogging = true;
      };
    };
  };
}
