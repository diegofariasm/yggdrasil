{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.app.connect;
in {
  options.modules.desktop.app.connect = {
    enable = lib.mkOption {
      description = ''
        Whether to install connect
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    services.kdeconnect.enable = true;
  };
}
