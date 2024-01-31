{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.apps.eza;
in
{
  options.modules.shell.apps.eza = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the eza package for the shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ eza ];
  };
}
