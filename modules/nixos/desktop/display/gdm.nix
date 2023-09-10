{ config
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.display.gdm;
in
{
  options.modules.desktop.display.gdm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        autoSuspend = true;
      };
    };
  };

}
