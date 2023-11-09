{ config, options, lib, pkgs, ... }:

let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf ((lib.countAttrs (name: value: name == "enable" && value) cfg) > 0) {
    environment.systemPackages = with pkgs; [
      brightnessctl
      libnotify
    ];
  };

}
