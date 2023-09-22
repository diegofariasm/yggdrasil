{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.services.clipman;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.services.clipman = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the dunst service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      clipman = {
        enable = true;
      };
    };
  };
}
