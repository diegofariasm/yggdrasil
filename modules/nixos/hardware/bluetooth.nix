{ config
, lib
, ...
}:

 let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
      enable = lib.mkOption {
      
     type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # In case you are not using a dwm.
    # You probably shouldn't be.
    services.blueman.enable = true;

    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };
}
