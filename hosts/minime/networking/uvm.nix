{ ... }:
{
  # TODO: make a module
  systemd.network = {
    netdevs."10-microvm" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "microvm";
      };
    };

    networks."10-microvm" = {
      matchConfig.Name = "microvm";
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

    networks."11-microvm" = {
      matchConfig.Name = "uvm-*";
      networkConfig.Bridge = "microvm";
    };

  };
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "enp90s0";
    internalInterfaces = [ "microvm" ];
  };
}
