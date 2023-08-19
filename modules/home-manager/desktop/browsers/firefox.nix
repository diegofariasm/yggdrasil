{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.browsers.firefox;


in
{
  options.modules.desktop.browsers.firefox = {
    enable = lib.mkOption {
      description = ''
        Wheter to installfirefox.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      firefox
      (makeDesktopItem {
        name = "firefox-private";
        desktopName = "Firefox (Private)";
        genericName = "Open a private Firefox window";
        icon = "firefox";
        exec = "${firefox}/bin/firefox --private-window";
        categories = [ "Network" ];
      })
    ];
  };
}
