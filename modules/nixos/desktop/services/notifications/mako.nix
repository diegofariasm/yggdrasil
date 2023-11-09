{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.services.notifications.mako;
in
{
  options.modules.desktop.services.notifications.mako = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the mako service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      # The mako service.
      # This is meant to be handling notifications.
      mako = {
        enable = true;
        wantedBy = [
          "graphical-session.target"
        ];
        after = [ "graphical-session.target" ];
        serviceConfig.ExecStart = "${pkgs.mako}/bin/mako";
      };
    };
    environment.systemPackages = with pkgs; [ mako ];
  };
}
