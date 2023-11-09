{ pkgs, config, lib, ... }:

let
  cfg = config.modules.shell.zsh;
in
{
  options.modules.shell.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };
    users.defaultUserShell = pkgs.zsh;

  };
}
