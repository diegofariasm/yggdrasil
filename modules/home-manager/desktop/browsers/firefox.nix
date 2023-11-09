{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.browsers.firefox;
in
{
  options.modules.desktop.browsers.firefox = {
    enable = lib.mkOption {
      description = ''
        Wheter to install firefox.
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
