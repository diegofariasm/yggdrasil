{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.mate-polkit;
in {
  options.modules.services.mate-polkit = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      mate.mate-polkit
      polkit
      polkit_gnome
    ];

    systemd.user.services.auth-agent = {
      script = ''
        "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
      '';
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
    };
  };
}
