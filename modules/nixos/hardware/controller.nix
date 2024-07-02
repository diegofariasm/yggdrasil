{
  config,
  lib,
  ...
}: let
  cfg = config.modules.hardware.controller;
in {
  options.modules.hardware.controller.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      xpadneo
    ];
  };
}
