{ ... }:
{
  # TODO: make a module
  systemd.network = {
    netdevs."10-uvm-br" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "uvm-br";
      };
    };

    networks."10-uvm-br" = {
      matchConfig.Name = "uvm-br";
      networkConfig = {
        DHCPServer = false;
        IPv6SendRA = true;
      };
      addresses = [
        {
          Address = "10.99.99.1/24";
        }
        {
          Address = "fd12:3456:789a::1/64";
        }
      ];
      ipv6Prefixes = [
        {
          Prefix = "fd12:3456:789a::/64";
        }
      ];
    };

    networks."11-uvm-br" = {
      matchConfig.Name = "uvm-*";
      networkConfig.Bridge = "uvm-br";
    };

  };
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "enp90s0";
    internalInterfaces = [ "uvm-br" ];
  };
}
