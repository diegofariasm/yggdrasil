{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.editor.zed;
in {
  options.modules.editor.zed = {
    enable = lib.mkOption {
      description = ''
        Whether to install zed.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zed-editor
    ];
  };
}
