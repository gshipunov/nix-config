{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    flake-utils.url = "github:numtide/flake-utils";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs-stable";
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
  };

  outputs =
    inputs@{ self
    , fenix
    , flake-utils
    , lanzaboote
    , microvm
    , nixpkgs-stable
    , nixpkgs-unstable
    , sops-nix
    , ...
    }:

    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs-stable = nixpkgs-stable.legacyPackages.${system};
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      in
      {
        packages.slick = pkgs-unstable.callPackage "${self}/pkgs/slick.nix" { };
        # packages.imhex = pkgs-unstable.libsForQt5.callPackage "${self}/pkgs/imhex.nix" { };
      })
    //
    {
      overlays.default = _final: prev: {
        inherit (self.packages.${prev.system})
          slick;
      };

      nixosConfigurations = {
        cirrus = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            ./hosts/cirrus
            ./modules/basic-tools
            ./modules/server
          ];
        };

        dishwasher = nixpkgs-stable.lib.nixosSystem {
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

        nextcloud = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
            ./microvms/nextcloud
            ./modules/server
          ];
        };

        music = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
            ./microvms/music
            ./modules/server
          ];
        };

        news = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
            ./microvms/news
            ./modules/server
          ];
        };

        noctilucent = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops

            ./hosts/noctilucent
            ./modules/server

            ./modules/basic-tools
            ./modules/binary-caches.nix
          ];
        };
      };

      hydraJobs =
        let
          get-toplevel = (host: nixSystem: nixSystem.config.microvm.declaredRunner or nixSystem.config.system.build.toplevel);
        in
        nixpkgs-stable.lib.mapAttrs get-toplevel self.nixosConfigurations;
    };
}
