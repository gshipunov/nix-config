{ ... }:
{
  imports = [
    ./ssh.nix
  ];

  networking.firewall.enable = true;
}
