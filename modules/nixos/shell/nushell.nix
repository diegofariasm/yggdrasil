{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.shell.nushell;
in {
  options.modules.shell.nushell.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    users.defaultUserShell = pkgs.nushell;
  };
}
