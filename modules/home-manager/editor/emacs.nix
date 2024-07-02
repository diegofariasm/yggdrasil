{
  config,
  lib,
  ...
}: let
  cfg = config.modules.editor.emacs;
in {
  options.modules.editor.emacs = {
    enable = lib.mkOption {
      description = ''
        Whether to install emacs.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.emacs.enable = true;
    services.emacs.enable = true;
  };
}
