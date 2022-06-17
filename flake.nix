{
  inputs = {
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = github:astro/microvm.nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, sops-nix, microvm, ... }: {
    nixosConfigurations = {
      microwave = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          sops-nix.nixosModules.sops
          ./hosts/microwave/configuration.nix
          ./hosts/microwave/secrets.nix
          ./hosts/microwave/hardware-configuration.nix
          ./modules/graphical.nix
          ./modules/basic-tools.nix
          ./modules/gnupg.nix
          ./modules/hw-accel-intel.nix
          ./modules/kernel-latest.nix
          ./modules/virtualization.nix
          ./modules/radio.nix
          ./modules/tlp.nix
          ./modules/wireguard.nix
          ./modules/binary-caches.nix
          ./modules/science.nix
          ./modules/mail.nix
        ];
      };
    };
  };
}
