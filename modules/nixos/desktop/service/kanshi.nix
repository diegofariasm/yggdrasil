{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.service.kanshi;
in {
  options.modules.desktop.service.kanshi = {
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
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.kanshi}/bin/kanshi'';
      };
    };
  };
}
