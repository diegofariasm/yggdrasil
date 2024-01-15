{ pkgs, config, inputs, lib, ... }:

let
  cfg = config.modules.desktop.gaming.steam;
in
{
  options.modules.desktop.gaming.steam.enable = lib.my.mkOpt' lib.types.bool false "Wheter to enable steam";

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;
  };
}
