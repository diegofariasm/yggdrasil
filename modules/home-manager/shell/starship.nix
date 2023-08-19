{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.starship;
  configDir = config.dotfiles.configDir;
in
{
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

    # Install the starship binary
    home.packages = with pkgs;  [
      icomoon
      starship
    ];

    # Looks too bad without the font.
    # How could you, nixos?!
    xdg.configFile = {
      "starship.toml" = {
        source = "${configDir}/starship.toml";
      };
    };

  };
}
