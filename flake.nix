{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    flake-utils.url = "github:numtide/flake-utils";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # microvm = {
    #   url = "github:astro/microvm.nix/v0.4.0";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };

    tmux-yank = {
      url = "github:tmux-plugins/tmux-yank";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , flake-utils
    , microvm
    , nixpkgs-stable
    , nixpkgs-unstable
    , sops-nix
    , ...
    }:

    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = nixpkgs-stable.legacyPackages.${system};
      in
      {
        # packages.slick = pkgs.callPackage "${self}/pkgs/slick.nix" { };
        # packages.imhex = pkgs.libsForQt5.callPackage "${self}/pkgs/imhex.nix" { };
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
            # lanzaboote.nixosModules.lanzaboote

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

        # cirrus = nixpkgs-stable.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     sops-nix.nixosModules.sops
        #     ./hosts/cirrus
        #     ./modules/basic-tools
        #     ./modules/server
        #   ];
        # };

        # dishwasher = nixpkgs-stable.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     sops-nix.nixosModules.sops
        #     microvm.nixosModules.host
        #     ./hosts/dishwasher
        #     ./modules/basic-tools
        #     ./modules/binary-caches.nix
        #     ./modules/virtualization.nix
        #     ./modules/server
        #   ];
        # };

        # nextcloud = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     sops-nix.nixosModules.sops
        #     microvm.nixosModules.microvm
        #     ./microvms/nextcloud
        #     ./modules/server
        #   ];
        # };

        # music = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     sops-nix.nixosModules.sops
        #     microvm.nixosModules.microvm
        #     ./microvms/music
        #     ./modules/server
        #   ];
        # };

        # news = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     sops-nix.nixosModules.sops
        #     microvm.nixosModules.microvm
        #     ./microvms/news
        #     ./modules/server
        #   ];
        # };

        # noctilucent = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     sops-nix.nixosModules.sops

        #     ./hosts/noctilucent
        #     ./modules/server

        #     ./modules/basic-tools
        #     ./modules/binary-caches.nix
        #   ];
        # };
      };

      hydraJobs =
        let
          get-toplevel = (host: nixSystem: nixSystem.config.microvm.declaredRunner or nixSystem.config.system.build.toplevel);
        in
        nixpkgs-stable.lib.mapAttrs get-toplevel self.nixosConfigurations;
    };
}
