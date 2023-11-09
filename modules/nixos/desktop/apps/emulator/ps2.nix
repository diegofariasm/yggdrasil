{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.desktop.apps.gaming.emulator.ps2;
in
{
  options.modules.desktop.apps.gaming.emulator.ps2 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        pcsx2
      ];
  };
}

