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
