{ flake, ... }: {
  microvm.vms = {
    nextcloud = {
      flake = flake;
      updateFlake = "git+https://git.sr.ht/~oxapentane/oxalab-config?ref=master";
    };
    music = {
      flake = flake;
      updateFlake = "git+https://git.sr.ht/~oxapentane/oxalab-config?ref=master";
    };
  };
}
