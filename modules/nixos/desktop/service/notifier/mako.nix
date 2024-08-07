{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.service.notifier.mako;
in {
  options.modules.desktop.service.notifier.mako = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the mako service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.notifier-agent = {
      enable = true;
      partOf = ["graphical-session.target"];
      wantedBy = [
        "graphical-session.target"
      ];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecCondition = "${pkgs.bash}/bin/bash -c '[ -n $WAYLAND_DISPLAY ]'";
        ExecStart = "${pkgs.mako}/bin/mako";
        ExecReload = "${pkgs.mako}/bin/makoctl reload";
      };
    };
  };
}
