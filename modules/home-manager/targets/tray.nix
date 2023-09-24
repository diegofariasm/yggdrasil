{ config, lib, pkgs, ... }:

let
  cfg = config.modules.targets.tray;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.targets.tray = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the udiskie service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # A systemd target.
    # Some services need this, so we define it here.
    systemd.user.targets = {
      tray = {
        Unit = {
          Description = "Home Manager System Tray";
          Requires = [ "graphical-session-pre.target" ];
        };
      };
    };

  };
}
