{ config
, lib
, ...
}:

let
  cfg = config.modules.boot.loader.display.lightdm;
in
{
  options.modules.boot.loader.display.lightdm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm = {
        enable = true;
      };
    };
  };
}
