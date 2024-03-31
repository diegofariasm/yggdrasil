{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.modules.desktop.plasma;
in {
  options.modules.desktop.plasma.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable the plasma desktop";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
  };
}
