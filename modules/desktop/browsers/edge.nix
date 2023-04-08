{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.edge;
in
{
  options.modules.desktop.browsers.edge = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      microsoft-edge
    ];
  };
}
