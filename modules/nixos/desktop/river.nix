{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.river;
in {
  options.modules.desktop.river.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable the river desktop";

  config = lib.mkIf cfg.enable {
    programs.river = {
      enable = true;
      package = pkgs.yggdrasil-river;
    };

    systemd.user = {
      services.river-session = {
        description = "river window manager session";
        wantedBy = ["river-session.target"];
        wants = ["river-session.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.coreutils}/bin/true";
          Restart = "on-failure";
        };
      };
      targets.river-session = {
        description = "river session";
        wantedBy = ["graphical-session.target"];
        requires = ["basic.target"];
        bindsTo = ["graphical-session.target"];
        before = ["graphical-session.target"];
        unitConfig = {
          DefaultDependencies = false;
          RefuseManualStart = true;
          RefuseManualStop = true;
          StopWhenUnneeded = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      rofi-wayland
      swww
      river-tag-overlay
    ];
  };
}
