{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.app.file.dolphin;
in {
  options.modules.desktop.app.file.dolphin = {
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
    home.packages = with pkgs;
    with libsForQt5; [
      dolphin
      kio
      ffmpegthumbs
      kio-extras
    ];
  };
}
