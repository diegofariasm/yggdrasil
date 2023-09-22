{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.services.notifications.mako;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.services.notifications.mako = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the mako service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      mako = {
        enable = true;
      };
    };

  };
}
