{ pkgs, lib, ... }: {
  nix = {
    registry.microvm = {
      from = {
        type = "indirect";
        id = "microvm";
      };
      to = {
        type = "github";
        owner = "astro";
        repo = "microvm.nix";
      };
    };
    settings = {
      trusted-users = [
        "grue"
        "@wheel"
      ];
      substituters = [
        "https://microvm.cachix.org"
        "https://nix-serve.hq.c3d2.de"
        "https://dump-dvb.cachix.org"
      ];
      trusted-substituters = [
        "https://microvm.cachix.org"
        "https://nix-serve.hq.c3d2.de"
        "https://dump-dvb.cachix.org"
      ];
      trusted-public-keys = [
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "nix-serve.hq.c3d2.de:KZRGGnwOYzys6pxgM8jlur36RmkJQ/y8y62e52fj1ps="
        "dump-dvb.cachix.org-1:+Dq7gqpQG4YlLA2X3xJsG1v3BrlUGGpVtUKWk0dTyUU="
      ];
    };
  };
}
