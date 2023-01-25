{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.media.editing;
in
{
  options.modules.desktop.media.editing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp-with-plugins
      # Plugins
      gimpPlugins.gmic
    ];
  };
}
