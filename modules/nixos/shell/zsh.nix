{ pkgs, config, lib, ... }:

let
  cfg = config.modules.shell.zsh;
in
{
  options.modules.shell.zsh.enable = lib.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };
    users.defaultUserShell = pkgs.zsh;
  };
}
