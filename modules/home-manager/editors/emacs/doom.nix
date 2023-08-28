{ config, lib, ... }:

let
  cfg = config.modules.editors.emacs.doom;
  configDir = config.dotfiles.configDir;
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

    doomEmacs = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/fushiii/doomemacs";
      description = ''The github url for the doom emacs config.'';
    };


    privateConfig = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/fushiii/doom";
      description = ''The github url for the private config.'';
    };

  };



  config = lib.mkIf (cfg.enable) {
    home = {
      mutableFile = {
        # My (your) private configuration for doom emacs
        ".config/doom" = {
          url = cfg.privateConfig;
          type = "git";
        };
        # Doom emacs configuration.
        ".config/emacs" = {
          url = cfg.doomEmacs;
          type = "git";
        };
      };

      # Add the doom binary to user path.
      # If you shell is not managed by home-manager,
      # you should add it yourself.
      sessionPath = [
        "$XDG_CONFIG_HOME/emacs/bin"
      ];

    };
  };


}
