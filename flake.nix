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
    rust-overlay = {
      url = github:oxalica/rust-overlay;
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, sops-nix, microvm, rust-overlay, ... }: {
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
          ./modules/radio.nix
          ./modules/tlp.nix
          ./modules/wireguard.nix
          ./modules/binary-caches.nix
          ./modules/science.nix
          ./modules/mail.nix
          ./modules/emacs.nix
          ./modules/virtualization.nix
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ rust-overlay.overlays.default ];
            environment.systemPackages = with pkgs; [
              rust-bin.stable.latest.default
              gcc
            ];
          })
        ];
      };
      cirrus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          sops-nix.nixosModules.sops
          ./hosts/cirrus
          ./modules/basic-tools.nix
        ];
      };
      dishwasher = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          sops-nix.nixosModules.sops
          microvm.nixosModules.host
          ./hosts/dishwasher
          ./modules/basic-tools.nix
          ./modules/binary-caches.nix
        ];
      };
      nextcloud = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          sops-nix.nixosModules.sops
          microvm.nixosModules.microvm
          ./microvms/nextcloud
        ];
      };
    };
  };
}
