{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the zsh package for the shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      sessionVariables = {
        EDITOR = "kak";
      };
    };
  };
}
