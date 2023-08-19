{ config, options, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.browsers.firefox;


in
{
  options.modules.desktop.browsers.firefox = {
    enable = lib.mkOption {
      description = ''
        Wheter to installfirefox.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      firefox
    ];
  };
}
