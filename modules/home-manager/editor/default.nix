{
  config,
  lib,
  ...
}: let
  cfg = config.modules.editor.default;
in {
  options.modules.editor.default = {
    bin = lib.mkOption {
      description = ''
        Binary location to the default editor
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.bin {
    home.sessionVariables = {
      EDITOR = cfg.bin;
    };
  };
}
