{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.services.polkit.kde;
in {
  options.modules.desktop.services.polkit.kde = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the kde service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.polkit-agent = {
      enable = true;
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
