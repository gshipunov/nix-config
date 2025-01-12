{ ... }: {
  systemd.network = {
    netdevs."10-uvm-br" = {
      netdevConfig = {
        Kind = bridge;
        Name = "uvm-br";
      };
    };

    networks."10-uvm-br" = {
      matchConfig.Name = "uvm-br";
      networkConfig = {
        DHCPServer = false;
        IPv6SendRA = true;
      };
      Address = [ ];
    };
  };
}
