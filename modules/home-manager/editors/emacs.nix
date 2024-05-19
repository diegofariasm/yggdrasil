{
  config,
  lib,
  ...
}: let
  cfg = config.modules.editors.emacs;
in {
  options.modules.editors.emacs = {
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
