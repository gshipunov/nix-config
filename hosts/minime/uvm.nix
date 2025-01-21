{ inputs, ... }:
{
  microvm.stateDir = "/var/lib/microvms";
  microvm.autostart = [
    "auth"
    "radicale"
    "immich"
  ];
  microvm.vms = {
    auth = {
      flake = inputs.self;
      updateFlake = "github:gshipunov/nix-config/master";
    };
    radicale = {
      flake = inputs.self;
      updateFlake = "github:gshipunov/nix-config/master";
    };
    immich = {
      flake = inputs.self;
      updateFlake = "github:gshipunov/nix-config/master";
    };
  };
}
