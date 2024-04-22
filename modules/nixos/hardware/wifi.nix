{
  config,
  lib,
  ...
}: let
  cfg = config.modules.hardware.wifi;
in {
  options.modules.hardware.wifi.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
    };
  };
}
