{
  config,
  lib,
  ...
}: let
  cfg = config.modules.boot.splash;
in {
  options.modules.boot.splash = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the splash on boot.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
    };
  };
}
