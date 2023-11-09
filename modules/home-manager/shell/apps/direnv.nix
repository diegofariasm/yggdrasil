{ config, pkgs, lib, ... }:

let
  cfg = config.modules.shell.apps.direnv;
in
{
  options.modules.shell.apps.direnv = {
    enable = lib.mkOption {
      description = ''
        Wheter to install the direnv package.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    home.packages = with pkgs; [ direnv ];
  };
}
