{ config, pkgs, lib, ... }:

let
  cfg = config.modules.shell.apps.fzf;
in
{
  options.modules.shell.apps.fzf = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable fzf.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
    };
    home.packages = with pkgs; [ fzf ];
  };
}
