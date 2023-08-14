{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.messengers.element;
in
{
  options.modules.desktop.apps.messengers.element = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      element-web
      element-desktop
    ];
  };
}
