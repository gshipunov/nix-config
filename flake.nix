{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    flake-utils.url = "github:numtide/flake-utils";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    microvm = {
      url = "github:astro/microvm.nix/v0.5.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    authentik-nix = {
      url = "github:nix-community/authentik-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmux-yank = {
      url = "github:tmux-plugins/tmux-yank";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      authentik-nix,
      flake-utils,
      lanzaboote,
      lix-module,
      microvm,
      nixos-hardware,
      nixpkgs,
      nixpkgs-unstable,
      sops-nix,
      ...
    }:

    {
      nixosConfigurations = {
        toaster = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            lanzaboote.nixosModules.lanzaboote
            nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3
            lix-module.nixosModules.default

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
        cloud = nixpkgs.lib.nixosSystem {
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
        minime = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.host

            ./hosts/minime
            ./modules/basic-tools
            ./modules/server
            ./modules/binary-caches.nix
            ./modules/wg
          ];
        };

        auth = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm
            authentik-nix.nixosModules.default

            ./hosts/auth
            ./modules/server
            ./modules/wg
          ];
        };

        radicale = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            microvm.nixosModules.microvm

            ./hosts/radicale
            ./modules/server
            ./modules/wg
          ];
        };
      };
    };
}
