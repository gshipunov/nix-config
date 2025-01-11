{
  lib,
  config,
  pkgs,
  ...
}:
{

  environment = {
    systemPackages = [ pkgs.fzf ];
    shellAliases = {
      vf = "$EDITOR $(fzf)";
      vff = "$EDITOR $(ls|fzf)";
    };
  };
  # integrate fzf into shell, >23.05 only
  programs =
    with lib;
    if (toInt (elemAt (splitVersion config.system.nixos.release) 0) >= 23) then
      {
        fzf = {
          keybindings = true;
          fuzzyCompletion = true;
        };
      }
    else
      { };
}
