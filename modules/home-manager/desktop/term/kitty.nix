{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.term.kitty;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term.kitty = {
    enable = lib.mkOption {
      description = ''
        Wheter to install kitty.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    # Install the kitty package
    home.packages = with pkgs; [ kitty ];

    # Install my kitty config.
    # You can also do that directly from the user,
    # if you want to specify different configs for the 
    # terminal.
    xdg.configFile = {
      "kitty" = {
        recursive = true;
        source = "${configDir}/kitty";
      };
    };
  };
}
