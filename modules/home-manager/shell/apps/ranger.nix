{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.shell.apps.ranger;
in {
  options.modules.shell.apps.ranger = {
    enable = lib.mkOption {
      description = ''
        Whether to enable ranger.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
       ranger
    ];
  };
}
