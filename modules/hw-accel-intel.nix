# overrides to enable [sometimes] wonky intel acceleration
{ config, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      vaapiIntel
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  boot.initrd.kernelModules = [ "i915" ];

}
