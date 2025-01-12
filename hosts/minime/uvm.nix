{ inputs, ... }:
{
  microvm.stateDir = "/var/lib/microvms";
  microvm.vms = {
    authentik = {
      flake = inputs.self;
      updateFlake = "github:gshipunov/nix-config/master";
    };
  };
}
