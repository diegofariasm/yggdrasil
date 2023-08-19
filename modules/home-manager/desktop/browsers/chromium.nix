{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.chromium;


in
{
  options.modules.desktop.chromium = {
    enable = lib.mkOption {
      description = ''
        Wheter to install chromium.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
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
