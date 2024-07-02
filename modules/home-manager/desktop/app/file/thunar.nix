{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.app.file.thunar;
in {
  options.modules.desktop.app.file.thunar = {
    enable = lib.mkOption {
      description = ''
        Whether to install thunar.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
    with xfce; [
      thunar
    ];
  };
}
