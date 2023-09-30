{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.eza;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.eza = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the eza package for the shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    programs.eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

  };
}
