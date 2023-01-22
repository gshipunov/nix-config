{ pkgs, config, ... }: {
  containers.irc = {
    autoStart = true;
    privateNetwork = true;
    localAddress = "10.34.44.100/24";

    config = { config, pkgs, ... }: {
      services.soju = {
        hostname = "mr_bouncy.oxapentane.com";
        enable = true;
        enableMessageLogging = true;
        acceptProxyIP = [
          "192.168.100.1"
        ];
      };

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 6697 22 ];
      };

      system.stateVersion = "22.11";
    };
  };
}
