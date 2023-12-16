{ config
, lib
, ...
}:

let
  cfg = config.modules.boot.loader.display.lightdm;
in
{
  options.modules.boot.loader.display.lightdm.enable = lib.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm = {
        enable = true;
      };
    };
  };
}
