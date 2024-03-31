{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.apps.kde.connect;
in {
  options.modules.desktop.apps.kde.connect.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable kdeconnect";

  config = lib.mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
    };
  };
}
