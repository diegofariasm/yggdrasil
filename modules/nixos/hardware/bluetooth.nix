{
  config,
  lib,
  ...
}: let
  cfg = config.modules.hardware.bluetooth;
in {
  options.modules.hardware.bluetooth.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
    };
  };
}
