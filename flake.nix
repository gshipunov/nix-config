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
    fenix = {
      url = github:nix-community/fenix;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , sops-nix
    , microvm
    , fenix
    , ...
    }:
    {
      nixosConfigurations = {
        microwave = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            ./hosts/microwave
            ./modules/basic-tools.nix
            ./modules/binary-caches.nix
            ./modules/gnupg.nix
            ./modules/graphical.nix
            ./modules/hw-accel-intel.nix
            ./modules/mail
            ./modules/radio.nix
            ./modules/science.nix
            ./modules/tlp.nix
            ({ pkgs, ... }: {
              nixpkgs.overlays = [ fenix.overlay ];
              environment.systemPackages = with pkgs; [
                (fenix.packages."x86_64-linux".stable.withComponents [
                  "cargo"
                  "clippy"
                  "rust-src"
                  "rustc"
                  "rustfmt"
                ])
                rust-analyzer-nightly
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

            {
              microvm.vms.nextcloud = {
                flake = self;
                updateFlake = "git+file:///etc/nixos";
              };
            }
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
