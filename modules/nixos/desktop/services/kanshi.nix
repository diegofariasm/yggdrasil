{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.services.kanshi;
in {
  options.modules.desktop.services.kanshi = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the kanshi service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.kanshi = {
      description = "kanshi daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.kanshi}/bin/kanshi'';
      };
    };
  };
}
