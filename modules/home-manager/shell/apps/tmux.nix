{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.apps.tmux;
in
{
  options.modules.shell.apps.tmux = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the tmux package for the shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    # programs.tmux = {
    #   enable = true;
    # };
    home.packages = with pkgs; [ tmux ];
  };
}
