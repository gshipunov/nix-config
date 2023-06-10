{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    flake-utils.url = "github:numtide/flake-utils";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    tmux-yank = {
      url = "github:tmux-plugins/tmux-yank";
      flake = false;
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-utils.follows = "flake-utils";
      };
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    inputs@{ self
    , emacs-overlay
    , fenix
    , flake-utils
    , lanzaboote
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
            lanzaboote.nixosModules.lanzaboote

            ./hosts/toaster

            ./modules/basic-tools
            ./modules/binary-caches.nix
            ./modules/devtools.nix
            ./modules/sway.nix
            ./modules/gnupg.nix
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
            ./modules/basic-tools
            ./modules/server
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
            ./modules/server
          ];
        };

        nextcloud = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
            ./microvms/nextcloud
            ./modules/server
          ];
        };

        music = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
            ./microvms/music
            ./modules/server
          ];
        };

        news = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
            ./microvms/news
            ./modules/server
          ];
        };
      };

      hydraJobs =
        let
          get-toplevel = (host: nixSystem: nixSystem.config.microvm.declaredRunner or nixSystem.config.system.build.toplevel);
        in
        nixpkgs.lib.mapAttrs get-toplevel self.nixosConfigurations;
    };
}
