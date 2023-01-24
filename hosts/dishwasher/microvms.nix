{ self, ... }: {
  microvm.vms = {
    nextcloud = {
      flake = self;
      updateFlake = "github:oxapentane/nix-config/master";
    };
    music = {
      flake = self;
      updateFlake = "github:oxapentane/nix-config/navidrome";
    };
  };
}
