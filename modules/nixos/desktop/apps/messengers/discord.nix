{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.messengers.discord;
in
{
  options.modules.desktop.apps.messengers.discord = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
