{ pkgs, inputs, ... }: {

  nixpkgs.overlays = [
    inputs.fenix.overlay
    inputs.emacs-overlay.overlay
  ];
  environment.systemPackages = with pkgs; [
    # general
    cmake
    gcc
    binutils
    clang
    clang-tools
    # rust
    (inputs.fenix.packages."x86_64-linux".stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
    # nix
    rnix-lsp
  ];
}
