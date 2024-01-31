{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.shell.apps.git;
in {
  options.modules.shell.apps.git = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the git package for the shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
    user = {
      email = lib.mkOption {
        type = lib.types.str;
        default = false;
        example = true;
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = false;
        example = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.user.name;
      userEmail = cfg.user.email;
    };
  };
}
