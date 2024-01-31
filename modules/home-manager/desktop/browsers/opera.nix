{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.browsers.opera;
in {
  options.modules.desktop.browsers.opera = {
    enable = lib.mkOption {
      description = ''
        Whether to install opera.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [opera];
  };
}
