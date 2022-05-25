{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # (rWrapper.override{ packages = with rPackages; [
    #                       ggplot2
    #                       swirl
    #                       languageserver
    #                       dplyr
    #                       data_table
    #                     ]; })
    #(rstudioWrapper.override{ packages = with rPackages; [ ggplot2 ]; })
    texlive.combined.scheme-full
    gnuplot
    graphicsmagick
    zotero
    python3Full
  ];
}
