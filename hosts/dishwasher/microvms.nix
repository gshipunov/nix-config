{ inputs, ... }: {
  microvm.vms = {
    nextcloud = {
      flake = inputs.self;
      updateFlake = "git+https://git.sr.ht/~oxapentane/oxalab-config?ref=master";
    };
    music = {
      flake = inputs.self;
      updateFlake = "git+https://git.sr.ht/~oxapentane/oxalab-config?ref=master";
    };
  };
}
