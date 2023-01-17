{ pkgs, inputs, ... }: {

  environment.systemPackages = with pkgs; [
    # general
    cmake
    gcc
    binutils
    clang
    clang-tools
    direnv
    (nix-direnv.override { enableFlakes = true; })
    # rust
    (inputs.fenix.packages."x86_64-linux".stable.toolchain)
    # nix
    rnix-lsp
    nil
    nixpkgs-fmt
    nix-index
    # julia
    julia
    # hardware
    kicad
  ];

  # Wireshark
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  users.users.grue.extraGroups = [ "wireshark" ];

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
  # nix options for derivations to persist garbage collection
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];
}
