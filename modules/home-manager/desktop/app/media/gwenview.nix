{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.app.media.gwenview;
in {
  options.modules.desktop.app.media.gwenview = {
    enable = lib.mkOption {
      description = ''
        Whether to install gwenview.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
    with libsForQt5; [
      gwenview
      phonon-backend-vlc
      # phonon-vlc
    ];
  };
}
