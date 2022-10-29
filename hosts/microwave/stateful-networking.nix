{ pkgs, config, ... }: {
  networking = {
    hostName = "microwave"; # Define your hostname.
    hostId = "7da4f1e6";
    firewall.enable = true;
    wireguard.enable = true;
    # wireless.iwd.enable = true;
    # networkmanager.wifi.backend = "iwd";
  };

  # fix networkmanager wireguard
 networking.firewall = {
   # if packets are still dropped, they will show up in dmesg
   logReversePathDrops = true;
   # wireguard trips rpfilter up
   extraCommands = ''
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
   '';
   extraStopCommands = ''
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
   '';
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
  };
}
