{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.desktop.app.gaming.lutris;
in {
  options.modules.desktop.app.gaming.lutris.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable lutris";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
