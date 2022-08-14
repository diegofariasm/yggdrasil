{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.motrix;
in
{
  options.modules.desktop.apps.motrix = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      my.motrix
      (makeDesktopItem {
        name = "motrix";
        desktopName = "motrix";
        genericName = "Open the motrix client";
        icon = "Motrix";
        exec = "${my.motrix}/bin/Motrix ";
        categories = [ "Network" ];
      })
    ];

  };
}
