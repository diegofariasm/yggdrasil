{ pkgs, config, inputs, lib, ... }:
let
  cfg = config.modules.desktop;
in
{

  config =
    let
      enabledDesktops = lib.countAttrs (_: module: lib.isAttrs module && builtins.hasAttr "enable" module && module.enable) cfg;
    in
    lib.mkIf (enabledDesktops > 0) {
      assertions =
        [{
          assertion = enabledDesktops <= 1;
          message = ''
            Only one desktop setup should be enabled at any given time.
          '';
        }];

      fonts.packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "Iosevka"
          ];
        })
      ];


      xdg.portal = {
        enable = true;
        wlr.enable = true;
        config.common.default = [
          "wlr"
        ];
      };


      environment.systemPackages = with pkgs; [
        jq
        socat
        libnotify
        wl-clipboard
      ];

    };

}
