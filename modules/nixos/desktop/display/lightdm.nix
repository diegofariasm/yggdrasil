{ config
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.display.lightdm;
in
{
  options.modules.desktop.display.lightdm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm = {
        enable = true;
      };
    };

  };
}
