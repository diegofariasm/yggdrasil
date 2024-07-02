{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.service.polkit.gnome;
in {
  options.modules.desktop.service.polkit.gnome = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the gnome service.
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
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
