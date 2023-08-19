{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.thunar;
in
{
  options.modules.desktop.apps.thunar = {
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
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };
}
