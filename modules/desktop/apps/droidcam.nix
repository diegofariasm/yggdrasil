{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.droidcam;
in
{
  options.modules.desktop.apps.droidcam = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.droidcam.enable = true;
  };
}

