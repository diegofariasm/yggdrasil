{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.app.connect;
in {
  options.modules.desktop.app.connect.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable the connect app";

  config = lib.mkIf cfg.enable {
    programs.kdeconnect.enable = true;
  };
}
