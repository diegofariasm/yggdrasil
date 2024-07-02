{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop;
in {
  config = let
    enabledDesktops = lib.my.countAttrs (_: module: lib.isAttrs module && builtins.hasAttr "enable" module && module.enable) cfg;
  in
    lib.mkIf (enabledDesktops > 0) {
      assertions = [
        {
          assertion = enabledDesktops <= 1;
          message = ''
            Only one desktop setup should be enabled at any given time.
          '';
        }
      ];

      fonts.packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "Ubuntu"
          ];
        })
        icomoon
      ];

      qt = {
        enable = true;
        platformTheme = "qt5ct";
      };

      services.gvfs.enable = true;

      environment = {
        systemPackages = with pkgs; [
          recolor
          imagecolorizer
          yggdrasil-flavours
          libnotify
          brightnessctl
          adw-gtk3
          wlr-randr
          xsettingsd
          wl-clipboard
          breeze-qt5
          yggdrasil
          breeze-icons
          breeze-gtk
        ];
      };

      systemd.user = {
        services = {
          desktop-session = {
            description = "desktop session";
            wantedBy = ["desktop-session.target"];
            wants = ["desktop-session.target"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
              Restart = "on-failure";
            };
          };

          desktop-shell = {
            description = "desktop shell";
            wantedBy = ["desktop-session.target"];
            wants = ["desktop-session.target"];
            serviceConfig = {
              ExecStart = "${pkgs.yggdrasil-shell}/bin/yggdrasil-shell";
            };
          };
        };

        targets = {
          desktop-session = {
            description = "desktop session";
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
      };
    };
}
