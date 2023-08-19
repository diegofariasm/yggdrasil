{ config, options, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.chromium;


in
{
  options.modules.desktop.chromium = {
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
