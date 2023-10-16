{ pkgs, config, inputs, lib, ... }:


let cfg = config.modules.desktop.apps.gaming.emulators.ps2;

in
{
  options.modules.desktop.apps.gaming.emulators.ps2 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      # The things needed to run ps2 games.
      systemPackages = with pkgs; [
        pcsx2
      ];
    };

  };
}

