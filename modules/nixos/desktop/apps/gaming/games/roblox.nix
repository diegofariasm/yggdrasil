{ pkgs, config, inputs, lib, ... }:


let cfg = config.modules.desktop.apps.gaming.games.roblox;

in {
  options.modules.desktop.apps.gaming.games.roblox = {
      enable = lib.mkOption {
      
     type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs;  [
        grapejuice
      ];
    };
    hardware.opengl.driSupport32Bit = true;
  };
}
