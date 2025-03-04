{ ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernelParams = [
    # use new amd pstate driver
    "amd_pstate=active"
    # fix flicker
    "amdgpu.dcdebugmask=0x10"
  ];

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
