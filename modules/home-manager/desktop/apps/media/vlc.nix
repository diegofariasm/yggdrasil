{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.media.vlc;
in
{
  options.modules.desktop.apps.media.vlc = {
    enable = lib.mkOption {
      description = ''
        Wheter to install vlc.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
