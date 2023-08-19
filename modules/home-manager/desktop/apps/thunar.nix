{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.thunar;
in
{
  options.modules.desktop.apps.thunar = {
    enable = lib.mkOption {
      description = ''
        Wheter to install thunar.
        A gtk file explorer.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      thunar
    ];
  };
}
