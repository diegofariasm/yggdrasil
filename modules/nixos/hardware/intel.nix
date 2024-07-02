{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hardware.intel;
in {
  options.modules.hardware.intel.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
  };
}
