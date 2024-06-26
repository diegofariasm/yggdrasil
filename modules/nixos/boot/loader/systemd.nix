{
  config,
  lib,
  ...
}: let
  cfg = config.modules.boot.loader.systemd;
in {
  options.modules.boot.loader.systemd.enable = lib.my.mkOpt lib.types.bool false;
  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
  };
}
