{ config
, lib
, ...
}:

 let
  cfg = config.modules.desktop.display.gdm;
in
{
  options.modules.desktop.display.gdm = {   enable = lib.mkOption {
      
     type = lib.types.bool;
      default = false;
      example = true;
    }; };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        autoSuspend = true;
      };
    };
  };

}
