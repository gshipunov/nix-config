{
  description = "oxa's system configs";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = github:astro/microvm.nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, sops-nix, microvm, ... }: {
    nixosConfigurations = {
      microwave = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          ./hosts/microwave/configuration.nix
          ./hosts/microwave/secrets.nix
          ./hosts/microwave/hardware-configuration.nix
          ./modules/graphical.nix
          ./modules/basic-tools.nix
          ./modules/gnupg.nix
          ./modules/hw-accel-intel.nix
          ./modules/kernel-latest.nix
          ./modules/virtualization.nix
          ./modules/emacs.nix
          ./modules/radio.nix
          ./modules/tlp.nix
          ./modules/chromium.nix
          ./modules/wireguard.nix
          ./modules/binary-caches.nix
          ./modules/science.nix
          ./modules/gnome.nix
        ];
      };
    };
  };
}
