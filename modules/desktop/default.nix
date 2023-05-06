{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in
{
  config = mkIf config.services.xserver.enable {

    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message = "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion =
          let srv = config.services;
          in
          srv.xserver.enable ||
          srv.sway.enable ||
          !(anyAttrs
            (n: v: isAttrs v &&
            anyAttrs (n: v: isAttrs v && v.enable))
            cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    # Pretty boot splash
    boot.plymouth.enable = true;

    home.packages = with pkgs; [
      feh
      xdotool
      xorg.xwininfo
      wl-clipboard
      wl-clipboard-x11
    ];

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        ubuntu_font_family
        dejavu_fonts
        symbola
        (nerdfonts.override {
          fonts = [
            "Iosevka"
          ];
        })

      ];
    };

    services.xserver.displayManager.sessionCommands = ''
      # GTK2_RC_FILES must be available to the display manager.
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    '';

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
      rm -rf .compose-cache .nv .pki .dbus
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}

