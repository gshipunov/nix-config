{ pkgs, ... }:
{

  environment.systemPackages =
    with pkgs;
    let
      kicad = pkgs.kicad.override {
        addons = with pkgs.kicadAddons; [
          kikit
          kikit-library
        ];
      };
    in
    [
      # general
      cmake
      gcc
      gef
      gdb
      binutils
      binwalk
      clang
      clang-tools
      direnv
      sops
      nil
      nixpkgs-fmt
      nix-index
      kicad
      freecad-wayland
      imhex
      python313Full
      nixfmt-rfc-style
      treefmt
      android-tools
    ];

  # android stuff
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  # Wireshark
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  users.users."0xa".extraGroups = [ "wireshark" ];

  ## Julia
  environment.variables = {
    JULIA_NUM_THREADS = "8";
  };

  ## direnv
  programs.bash.interactiveShellInit = ''
    eval "$(direnv hook bash)"
  '';
  programs.zsh.interactiveShellInit = ''
    eval "$(direnv hook zsh)"
  '';
  programs.fish.interactiveShellInit = ''
    direnv hook fish | source
  '';

  # nix options for derivations to persist garbage collection
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];
}
