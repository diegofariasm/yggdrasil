{ pkgs, config, inputs, lib, ... }:


let cfg = config.modules.desktop.apps.gaming.steam;

in
{
  options.modules.desktop.apps.gaming.steam = {   enable = lib.mkOption {
      
     type = lib.types.bool;
      default = false;
      example = true;
    }; };

  config = lib.mkIf cfg.enable {

    programs = {
      steam = {
        enable = true;
      };
    };
    hardware.steam-hardware.enable = true;

  };
}
