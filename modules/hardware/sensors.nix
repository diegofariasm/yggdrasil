{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.sensors;
in {
  options.modules.hardware.sensors = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.lm_sensors];
  };
}
