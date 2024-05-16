{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.apps.media.editor.gimp;
in {
  options.modules.desktop.apps.media.editor.gimp = {
    enable = lib.mkOption {
      description = ''
        Whether to install gimp.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
    ];
  };
}
