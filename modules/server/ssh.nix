{ ... }:
{
  programs.mosh.enable = true;
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHv82n6F6kwJ3/EMYlOoCc1/NaYFW7QHC5F8jKVzdlio gshipunov@toaster"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3to/h8Myn+zXAkjboaRVqOfmtDz7VpIHhHbaRoYyPX g.shipunov@uva.nl"
  ];
}
