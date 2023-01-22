{ lib, config, ... }: {
  # integrate fzf into shell, >23.05 only
  programs =
    if (lib.toInt (lib.elemAt (lib.splitVersion config.system.nixos.release) 0) >= 23) then {
      fzf = {
        keybindings = true;
        fuzzyCompletion = true;
      };
    } else { };
}
