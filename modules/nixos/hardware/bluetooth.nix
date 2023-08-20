{ config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
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
