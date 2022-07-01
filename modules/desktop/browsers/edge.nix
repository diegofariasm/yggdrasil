# modules/browser/brave.nix --- https://publishers.basicattentiontoken.org
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.edge;
in {
  options.modules.desktop.browsers.edge = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      microsoft-edge
      (makeDesktopItem {
        name = "edge-private";
        desktopName = "Edge Private";
        genericName = "Open a private Edge window";
        icon = "microsoft-edge";
        exec = "${microsoft-edge}/bin/microsoft-edge --inprivate";
        categories = ["Network"];
      })
    ];
  };
}
