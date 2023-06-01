# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    useDHCP = true;
    interfaces.enp1s0.useDHCP = true;
    hostName = "dishwasher"; # Define your hostname.
    useNetworkd = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Amsterdam";

  # fix wait-online target
  systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [
    "" # clear old command
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  systemd.network = {

    enable = true;

    networks."ether" = {
      matchConfig = {
        Name = "enp1s0";
      };
      networkConfig = {
        DHCP = "yes";
        LinkLocalAddressing = "ipv6";
        IPv6AcceptRA = "yes";
      };
      dhcpV6Config = {
        WithoutRA = "solicit";
      };
      ipv6AcceptRAConfig = {
        DHCPv6Client = "yes";
      };
    };
    networks."aer" = {
      matchConfig.Name = "wlan0";
      networkConfig = {
        DHCP = "yes";
      };
    };
  };

  services.resolved = {
    enable = true;
    fallbackDns = [
      "8.8.8.8"
      "2001:4860:4860::8844"
    ];
  };


  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "all" ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

