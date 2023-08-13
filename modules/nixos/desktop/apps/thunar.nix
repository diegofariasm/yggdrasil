{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.thunar;
in
{
  options.modules.desktop.apps.thunar = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.tumbler.enable = true;
    services.gvfs.enable = true;
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-dropbox-plugin
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
    home.packages = with pkgs; [ xfce.exo ];
  };
}
