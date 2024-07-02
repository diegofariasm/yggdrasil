{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.app.media.zathura;
in {
  options.modules.desktop.app.media.zathura = {
    enable = lib.mkOption {
      description = ''
        Whether to install zathura.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zathura
    ];
  };
}
