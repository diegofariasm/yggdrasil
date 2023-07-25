{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.brave;
in
{
  options.modules.desktop.browsers.brave = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      brave
      (makeDesktopItem {
        name = "brave-private";
        desktopName = "Brave (Private)";
        genericName = "Open a private brave window";
        icon = "brave";
        exec = "${brave}/bin/brave --private-window";
        categories = [ "Network" ];
      })
    ];

  };
}
