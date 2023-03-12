{ config
, options
, pkgs
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.polkit;
in
{
  options.modules.services.polkit = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    home.packages = with pkgs; [
      polkit_gnome
    ];
    systemd.user.services.auth-agent = {
      script = ''
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      '';
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };
}
