{ pkgs, config, inputs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.gaming.games.roblox;

in {
  options.modules.desktop.apps.gaming.games.roblox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs;  [
        grapejuice
      ];
    };
  };
}
