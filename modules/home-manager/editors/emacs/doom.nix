{ config, pkgs, lib, ... }:

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
    autoInstall = lib.mkOption {
      description = ''
        Wheter to auto install doom emacs.
      '';
      type = lib.types.bool;
      default = true;
      example = false;
    };

  };
  config = lib.mkIf cfg.enable {

    home.mutableFile = {
      ".config/emacs" = {
        url = "https://github.com/fushiii/doomemacs";
        type = "git";
      };
    };

    home.sessionPath = [
      "$XDG_CONFIG_HOME/emacs/bin"
    ];

  };
}
