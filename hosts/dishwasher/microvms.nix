{ inputs, ... }: {
  microvm.vms = {
    nextcloud = {
      flake = inputs.self;
      updateFlake = "github:oxapentane/nix-config/master";
    };
    music = {
      flake = inputs.self;
      updateFlake = "github:oxapentane/nix-config/master";
    };
    news = {
      flake = inputs.self;
      updateFlake = "github:oxapentane/nix-config/master";
    };
  };
}
