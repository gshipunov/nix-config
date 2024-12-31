{ pkgs, config, ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];

 #  hardware.graphics = {
 #    extraPackages = with pkgs; [
 #      rocm-opencl-icd
 #      rocm-opencl-runtime
 #      amdvlk
 #    ];
 #    extraPackages32 = with pkgs; [
 #      driversi686Linux.amdvlk
 #    ];
 #  };
}
