{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.dolphin;
in
{
  options.modules.desktop.apps.dolphin = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dolphin
      ffmpegthumbnailer
      thumbs
    ];
    services = {
      gvfs.enable = true; # Mount, trash, and other functionalities
    };
  };
}
