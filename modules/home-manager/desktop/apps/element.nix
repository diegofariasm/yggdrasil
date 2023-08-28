{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.element;
in
{
  options.modules.desktop.apps.element = {
    enable = lib.mkOption {
      description = ''Wheter to install element.'';
      example = true;
      default = false;
      type = lib.types.bool;
    };
    enableWeb = lib.mkOption {
      description = ''Wheter to enable element web.'';
      example = true;
      default = false;
      type = lib.types.bool;

    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; with xfce; [
      element-desktop
      (lib.mkIf cfg.enableWeb
        element-web
      )
    ];

  };
}
