{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.shell.apps.starship;
in {
  options.modules.shell.apps.starship = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the starship package for the shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [starship];
  };
}
