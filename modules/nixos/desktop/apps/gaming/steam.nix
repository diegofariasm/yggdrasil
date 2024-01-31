{ pkgs, config, inputs, lib, ... }:

let
  cfg = config.modules.desktop.apps.gaming.steam;
in
{
  options.modules.desktop.apps.gaming.steam.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable steam";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
    };
  };
}
