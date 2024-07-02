{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.app.gaming.steam;
in {
  options.modules.desktop.app.gaming.steam.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable steam";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
    };
  };
}
