{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.elvish;
in
{
  options.modules.shell.elvish = {
    enable = lib.mkOption {
      description = ''
        Wheter to install the elvish package.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    # Install the elvish binary
    home.packages = with pkgs; [
      exa
      elvish
    ];

    home.mutableFile = {
      "$XDG_CONFIG_HOME/elvish" = {
        type = "git";
        url = "https://github.com/fushiii/elvish";
      };
    };

  };
}
