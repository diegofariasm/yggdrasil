{
  config,
  lib,
  ...
}: let
  cfg = config.modules.hardware.ssd;
in {
  options.modules.hardware.ssd.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    services.fstrim = {
      enable = true;
    };
  };
}
