{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.term.kitty;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.term.kitty = {
    enable = lib.mkOption {
      description = ''
        Wheter to install kitty.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
      };
    };
    home = {
      packages = with pkgs; [
        kitty
      ];
    };
  };
}
