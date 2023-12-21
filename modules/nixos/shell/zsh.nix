{ pkgs, config, lib, ... }:

let
  cfg = config.modules.shell.zsh;
in
{
  options.modules.shell.zsh.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };
    users.defaultUserShell = pkgs.zsh;
  };
}
