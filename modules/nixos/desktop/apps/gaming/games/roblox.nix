{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.modules.desktop.apps.gaming.games.roblox;
in {
  options.modules.desktop.apps.gaming.games.roblox.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable roblox";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [grapejuice];
  };
}
