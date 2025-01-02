{ ... }:
{
  services.eternal-terminal.enable = true;
  programs.mosh.enable = true;
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [ 22 2020 ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJl9iYG5oHBq/poBn7Jf1/FGWWbAnbx+NKjs7qtT3uAK 0xa@toaster 2024-12-31"
  ];
}
