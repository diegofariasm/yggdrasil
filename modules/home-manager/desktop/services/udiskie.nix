{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.modules.desktop.services.udiskie;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.services.udiskie = {
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
    services = {
      udiskie = {
        enable = true;
        tray = "never";
      };
    };

    # Enable the systemd tray target.
    # This is needed or else the udiskie system fails.
    modules.targets.tray.enable = true;
  };
}
