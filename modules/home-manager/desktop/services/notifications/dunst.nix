{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.services.notifications.dunst;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.services.notifications.dunst = {
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
      dunst = {
        enable = true;
      };
    };
  };
}
