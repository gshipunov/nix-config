{ lib, ... }:
{
  networking.dhcpcd.enable = false;

  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network = {
    networks."30-uplink" = {
      matchConfig.Name = "enp1s0";
      networkConfig = {
        Address = [
          "188.245.196.27/32"
          "2a01:4f8:c17:7f8a::1/64"
        ];
        DNS = [
          "2a01:4ff:ff00::add:1"
          "2a01:4ff:ff00::add:2"
          "185.12.64.1"
        ];
      };
      routes = [
        {
          Gateway = "172.31.1.1";
          GatewayOnLink = true;
          Destination = "0.0.0.0/0";
        }
        {
          Gateway = "fe80::1";
          GatewayOnLink = true;
          Destination = "::/0";
        }
      ];
    };
  };
}
