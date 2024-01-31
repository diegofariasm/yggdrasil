{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.services.notifier.mako;
in {
  options.modules.desktop.services.notifier.mako = {
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
    systemd.user.services = {
      mako = {
        enable = true;
        wantedBy = [
          "graphical-session.target"
        ];
        after = ["graphical-session.target"];
        serviceConfig.ExecStart = "${pkgs.mako}/bin/mako";
      };
    };
    systemd.user.services.mako.bindsTo = ["graphical-session.target"];
  };
}
