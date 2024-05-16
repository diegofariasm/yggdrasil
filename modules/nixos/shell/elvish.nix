{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.shell.elvish;
in {
  options.modules.shell.elvish.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    users.defaultUserShell = pkgs.elvish;
  };
}
