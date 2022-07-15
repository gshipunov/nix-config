{
  inputs = {
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
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
    , home-manager
    , ...
    }:
    {
      nixosConfigurations = {
        microwave = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            ./hosts/microwave
            ./modules/graphical.nix
            ./modules/basic-tools.nix
            ./modules/gnupg.nix
            ./modules/hw-accel-intel.nix
            ./modules/radio.nix
            ./modules/tlp.nix
            ./modules/binary-caches.nix
            ./modules/science.nix
            ./modules/mail.nix
            ./modules/virtualization.nix
            ({ pkgs, ... }: {
              services.throttled.enable = true;
            })
            ({ pkgs, ... }: {
              nixpkgs.overlays = [ fenix.overlay ];
              environment.systemPackages = with pkgs; [
                (fenix.packages."x86_64-linux".complete.withComponents [
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
