{ config, pkgs, lib, ... }:

let
  cfg = config.modules.shell.fish;
in
{
  options.modules.shell.fish = {
    enable = lib.mkOption {
      description = ''
        Wheter to install the fish package.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
    };
    home.packages = with pkgs; [ fish ];
  };
}
