{ ... }: {
  nix = {
    extraOptions = ''
      builders-use-substitutes = true
    '';

    settings = {
      trusted-users = [
        "grue"
        "@wheel"
      ];
      substituters = [
        "https://microvm.cachix.org"
        "https://nix-serve.hq.c3d2.de"
        "https://dump-dvb.cachix.org"
        "https://tlm-solutions.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-substituters = [
        "https://microvm.cachix.org"
        "https://nix-serve.hq.c3d2.de"
        "https://dump-dvb.cachix.org"
        "https://tlm-solutions.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "nix-serve.hq.c3d2.de:KZRGGnwOYzys6pxgM8jlur36RmkJQ/y8y62e52fj1ps="
        "dump-dvb.cachix.org-1:+Dq7gqpQG4YlLA2X3xJsG1v3BrlUGGpVtUKWk0dTyUU="
        "tlm-solutions.cachix.org-1:J7qT6AvoNWPSj+59ed5bNESj35DLJNaROqga1EjVIoA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
