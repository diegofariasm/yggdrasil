{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.app.media.vlc;
in {
  options.modules.desktop.app.media.vlc = {
    enable = lib.mkOption {
      description = ''
        Whether to install vlc.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
