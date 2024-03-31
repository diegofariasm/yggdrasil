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
      notifier = {
        enable = true;
        wantedBy = [
          "graphical-session.target"
        ];
        bindsTo = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig.ExecStart = "${pkgs.mako}/bin/mako";
      };
    };

    environment.systemPackages = with pkgs; [
      mako
    ];
  };
}
