{ config, pkgs, lib, ... }:

let
  cfg = config.modules.shell.zsh;
in
{
  options.modules.shell.zsh = {
    enable = lib.mkOption {
      description = ''
        Wheter to install the zsh package.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };
    home.packages = with pkgs; [ zsh ];
  };
}
