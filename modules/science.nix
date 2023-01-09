{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (rWrapper.override {
      packages = with rPackages; [
        ggplot2
        swirl
        dplyr
        data_table
      ];
    })
    gnuplot
    zotero
    python3Full
  ];
}
