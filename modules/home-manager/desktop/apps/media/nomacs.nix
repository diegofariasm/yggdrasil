{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.apps.media.nomacs;
in {
  options.modules.desktop.apps.media.nomacs = {
    enable = lib.mkOption {
      description = ''
        Whether to install nomacs.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nomacs
    ];
  };
}
