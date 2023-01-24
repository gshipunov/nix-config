{ flake, ... }: {
  microvm.vms = {
    nextcloud = {
      flake = flake;
      updateFlake = "github:oxapentane/nix-config/master";
    };
    music = {
      flake = flake;
      updateFlake = "github:oxapentane/nix-config/master";
    };
  };
}
