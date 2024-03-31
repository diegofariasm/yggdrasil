{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.apps.files.dolphin;
in {
  options.modules.desktop.apps.files.dolphin = {
    enable = lib.mkOption {
      description = ''
        Whether to install dolphin.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dolphin
    ];
  };
}
