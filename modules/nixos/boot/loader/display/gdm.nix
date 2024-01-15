{ config
, lib
, ...
}:
let
  cfg = config.modules.boot.loader.display.gdm;
in
{
  options.modules.boot.loader.display.gdm.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
      };
    };
  };
}
