{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.apps.eza;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.apps.eza = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the eza package for the shell.apps.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
    };
    home.packages = with pkgs; [ eza ];
  };
}
