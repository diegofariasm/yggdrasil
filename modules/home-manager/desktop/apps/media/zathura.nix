{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.media.zathura;
in
{
  options.modules.desktop.apps.media.zathura = {
    enable = lib.mkOption {
      description = ''
        Wheter to install zathura.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zathura
    ];
  };
}
