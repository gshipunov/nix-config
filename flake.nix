{
  inputs = {
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;

    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;

    flake-utils.url = github:numtide/flake-utils;

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

    emacs-overlay.url = github:nix-community/emacs-overlay;
  };

  outputs =
    inputs@{ self
    , emacs-overlay
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
        packages.imhex = pkgs.callPackage "${self}/pkgs/imhex.nix" { };
      })
    //
    {
      overlays.default = final: prev: {
        inherit (self.packages.${prev.system})
          slick;
      };
      nixosConfigurations = {
        microwave = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            ./hosts/microwave
            ./modules/basic-tools.nix
            ./modules/binary-caches.nix
            ./modules/chromium.nix
            ./modules/devtools.nix
            ./modules/emacs.nix
            ./modules/gnupg.nix
            ./modules/gnome.nix
            ./modules/hw-accel-intel.nix
            ./modules/mail
            ./modules/radio.nix
            ./modules/science.nix
            ./modules/tlp.nix
            ./modules/virtualization.nix
          ];
        };
        cirrus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            ./hosts/cirrus
            ./modules/basic-tools.nix
          ];
        };
        dishwasher = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.host
            ./hosts/dishwasher
            ./modules/basic-tools.nix
            ./modules/binary-caches.nix

            {
              microvm.vms.nextcloud = {
                flake = self;
                updateFlake = "github:oxapentane/nix-config/master";
              };
            }
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
      };
    };
}
