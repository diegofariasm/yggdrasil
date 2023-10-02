{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.browsers.chromium;
in
{
  options.modules.desktop.browsers.chromium = {
    enable = lib.mkOption {
      description = ''
        Wheter to install chromium.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      chromium
    ];
  };
}
