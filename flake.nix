{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    flake-utils.url = "github:numtide/flake-utils";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    tmux-yank = {
      url = "github:tmux-plugins/tmux-yank";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , fenix
    , flake-utils
    , microvm
    , nixpkgs
    , nixpkgs-unstable
    , sops-nix
    , ...
    }:

    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.slick = pkgs.callPackage "${self}/pkgs/slick.nix" { };
        packages.imhex = pkgs.libsForQt5.callPackage "${self}/pkgs/imhex.nix" { };
      })
    //
    {
      overlays.default = _final: prev: {
        inherit (self.packages.${prev.system})
          slick;
      };

      nixosConfigurations = {
        toaster = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops

            ./hosts/toaster

            ./modules/basic-tools
            ./modules/binary-caches.nix
            ./modules/devtools.nix
            ./modules/gnupg.nix
            ./modules/mail
            ./modules/radio.nix
            ./modules/science.nix
            ./modules/sway.nix
            ./modules/tlp.nix
            ./modules/virtualization.nix
          ];
        };

        microwave = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops

            ./hosts/microwave

            ./modules/basic-tools
            ./modules/binary-caches.nix
            ./modules/devtools.nix
            ./modules/gnupg.nix
            ./modules/sway.nix
            ./modules/hw-accel-intel.nix
            ./modules/tlp.nix
          ];
        };

        cirrus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            ./hosts/cirrus
            ./modules/basic-tools
          ];
        };

        dishwasher = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.host
            ./hosts/dishwasher
            ./modules/basic-tools
            ./modules/binary-caches.nix
          ];
        };

        nextcloud = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
            ./microvms/nextcloud
          ];
        };

        music = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
            ./microvms/music
          ];
        };

        news = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
          ];
        };
      };
    };
}
