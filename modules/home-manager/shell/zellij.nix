{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.zellij;
in
{
  options.modules.shell.zellij = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the zellij package for the shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ zellij ];
  };
}
