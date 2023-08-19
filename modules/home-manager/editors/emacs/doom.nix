{ config, options, lib, pkgs, ... }:

let
  cfg = config.modules.editors.emacs.doom;
in
{
  options.modules.editors.emacs.doom = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable my doom emacs config.

        You should probably have emacs if you want to use this, i guess.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    home.mutableFile = {
      ".config/emacs" = {
        url = "https://github.com/doomemacs/doomemacs";
        type = "git";
      };
    };

  };
}
