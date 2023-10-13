{ config
, lib
, ...
}:

 let
  cfg = config.modules.desktop.display.lightdm;
in
{
  options.modules.desktop.display.lightdm = {   enable = lib.mkOption {
      
     type = lib.types.bool;
      default = false;
      example = true;
    }; };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm = {
        enable = true;
      };
    };

  };
}
