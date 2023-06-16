{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.chromium;
in
{
  options.modules.desktop.browsers.chromium = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      chromium
      (makeDesktopItem {
        name = "chromium-private";
        desktopName = "Chromium (Private)";
        genericName = "Open a private chromium window";
        icon = "chromium";
        exec = "${chromium}/bin/chromium --private-window";
        categories = [ "Network" ];
      })
    ];

  };
}
