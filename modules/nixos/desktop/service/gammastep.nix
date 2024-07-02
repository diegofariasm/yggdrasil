{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.service.gammastep;
in {
  options.modules.desktop.service.gammastep = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the gammastep service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.geoclue2.enable = true;

    systemd.user.services.gammastep = {
      description = "gammastep daemon";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.gammastep}/bin/gammastep'';
      };
    };
  };
}
