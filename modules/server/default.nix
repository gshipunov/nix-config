{ ... }:
{
  imports = [
    ./ssh.nix
  ];

  networking.firewall.enable = true;

  # unpriviliged user
  security.sudo.enable = true;
  users.users."0xa" = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHv82n6F6kwJ3/EMYlOoCc1/NaYFW7QHC5F8jKVzdlio gshipunov@toaster"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3to/h8Myn+zXAkjboaRVqOfmtDz7VpIHhHbaRoYyPX g.shipunov@uva.nl"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPPG1va3CG8uAXV+ACRFPdi8FicpdOyXqb7eSZJCPXx pixel"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJl9iYG5oHBq/poBn7Jf1/FGWWbAnbx+NKjs7qtT3uAK 0xa@toaster 2024-12-31"
    ];
    extraGroups = [
      "wheel"
    ];
    group = "users";
    home = "/home/0xa";
    isNormalUser = true;
    uid = 1000;
  };
}
