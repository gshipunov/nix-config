{ ... }:
{
  services.eternal-terminal.enable = true;
  programs.mosh.enable = true;
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHv82n6F6kwJ3/EMYlOoCc1/NaYFW7QHC5F8jKVzdlio gshipunov@toaster"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3to/h8Myn+zXAkjboaRVqOfmtDz7VpIHhHbaRoYyPX g.shipunov@uva.nl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlRhs/h3zTfonh/8wTZPEHnLAWXtedpF3ulJOwDbTGL owner@pixel"
  ];
}
