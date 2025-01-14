{ inputs, ... }:
{
  microvm.stateDir = "/var/lib/microvms";
  microvm.vms = {
    auth = {
      flake = inputs.self;
      updateFlake = "github:gshipunov/nix-config/master";
    };
    radicale = {
      flake = inputs.self;
      updateFlake = "github:gshipunov/nix-config/master";
    };
  };
}
