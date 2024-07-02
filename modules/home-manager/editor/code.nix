{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.editor.code;
in {
  options.modules.editor.code = {
    enable = lib.mkOption {
      description = ''
        Whether to install code.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode
    ];
  };
}
