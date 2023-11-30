{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.desktop.apps.gaming.bottles;
in
{
  options.modules.desktop.apps.gaming.bottles = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}

