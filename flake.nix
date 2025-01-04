{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    flake-utils.url = "github:numtide/flake-utils";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    microvm = {
      url = "github:astro/microvm.nix/v0.5.0";
      inputs = {
        nixpkgs.follows = "nixpkgs-stable";
        flake-utils.follows = "flake-utils";
      };
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    tmux-yank = {
      url = "github:tmux-plugins/tmux-yank";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , flake-utils
    , lanzaboote
    , microvm
    , nixos-hardware
    , nixpkgs-stable
    , nixpkgs-unstable
    , sops-nix
    , ...
  }:

  {
    nixosConfigurations = {
      toaster = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3

          ./hosts/toaster

          ./modules/basic-tools
          ./modules/binary-caches.nix
          ./modules/devtools.nix
          ./modules/gnome.nix
          ./modules/gnupg.nix
          ./modules/radio.nix
          ./modules/science.nix
          ./modules/tlp.nix
          ./modules/virtualization.nix
          ./hosts/toaster/secure-boot.nix
          ./modules/chromium.nix
          ./modules/mail
          ./modules/wg
          ];
        };
        cloud = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops

            ./hosts/cloud

            ./modules/basic-tools
            ./modules/server
            ./modules/binary-caches.nix
            ./modules/wg
          ];
        };
        minime = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops

            ./hosts/minime
            ./modules/basic-tools
            ./modules/server
            ./modules/binary-caches.nix
            ./modules/wg
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
