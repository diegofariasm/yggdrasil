{ config, pkgs, lib, ... }:

let
  cfg = config.modules.shell.direnv;
in
{
  options.modules.shell.direnv = {
    enable = lib.mkOption {
      description = ''
        Whether to install the direnv package.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ direnv ];
  };
}
