{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnuplot
    zotero
    paraview
    numbat
  ];
}
