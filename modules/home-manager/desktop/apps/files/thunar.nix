{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.files.thunar;
in
{
  options.modules.desktop.apps.files.thunar = {
    enable = lib.mkOption {
      description = ''
        Wheter to install thunar.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; with xfce; [
      thunar
    ];
  };
}
