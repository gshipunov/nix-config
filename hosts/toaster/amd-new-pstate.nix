{ ... }:
{
  # use new amd pstate driver
  boot.kernelParams = [ "amd_pstate=active" ];
}
