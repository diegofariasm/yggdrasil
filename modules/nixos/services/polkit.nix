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
    user.packages = with pkgs; [
      mate.mate-polkit
    ];
    systemd.user.services.auth-agent = {
      script = ''
        "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
      '';
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };
}
