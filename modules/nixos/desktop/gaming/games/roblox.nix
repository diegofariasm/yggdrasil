{ pkgs, config, inputs, lib, ... }:

let
  cfg = config.modules.desktop.gaming.games.roblox;
in
{
  options.modules.desktop.gaming.games.roblox.enable = lib.my.mkOpt' lib.types.bool false "Wheter to enable roblox";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ grapejuice ];
  };
}
