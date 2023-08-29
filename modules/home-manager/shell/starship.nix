{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.starship;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.starship = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the starship package for the shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    # A needed font
    home.packages = with pkgs; [ icomoon ];

  };
}
