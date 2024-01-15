{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.services.clipman;
in
{
  options.modules.desktop.services.clipman = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the clipman service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      clipman = {
        enable = true;
        wantedBy = [
          "graphical-session.target"
        ];
        after = [ "graphical-session.target" ];
        serviceConfig.ExecStart = "${pkgs.clipman}/bin/clipman";
      };
    };
    systemd.user.services.clipman.bindsTo = [ "graphical-session.target" ];

  };
}
