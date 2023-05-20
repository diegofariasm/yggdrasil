{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.teamviewer;
in
{
  options.modules.desktop.apps.teamviewer = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.teamviewer.enable = true;
    home.packages = with pkgs; [
      teamviewer
    ];
  };
}
