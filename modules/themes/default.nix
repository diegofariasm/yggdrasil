# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in
{
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      apply = v:
        let theme = builtins.getEnv "THEME"; in
        if theme != "" then theme else v;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable. Themes can also be hot-swapped with 'hey theme $THEME'.
      '';
    };

    gtk = {
      theme = mkOpt str "";
      iconTheme = mkOpt str "";
      cursorTheme = mkOpt str "";
    };

    onReload = mkOpt (attrsOf lines) { };

    fonts = {
      # TODO Use submodules
      mono = {
        name = mkOpt str "Monospace";
        size = mkOpt int 12;
      };
      sans = {
        name = mkOpt str "Sans";
        size = mkOpt int 10;
      };
    };

  };

  config = mkIf (cfg.active != null) (mkMerge [
    {
      home.packages = with pkgs; [
        qgnomeplatform # QPlatformTheme for a better Qt application inclusion in GNOME
        libsForQt5.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra theme
      ];

      # Try really hard to get QT to respect my GTK theme.
      env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
      env.QT_QPA_PLATFORMTHEME = "gnome";
      env.QT_STYLE_OVERRIDE = "kvantum";

      home.configFile = {
        # GTK
        "gtk-3.0/settings.ini".text = ''
          [Settings]
          ${optionalString (cfg.gtk.theme != "")
            ''gtk-theme-name=${cfg.gtk.theme}''}
          ${optionalString (cfg.gtk.iconTheme != "")
            ''gtk-icon-theme-name=${cfg.gtk.iconTheme}''}
          ${optionalString (cfg.gtk.cursorTheme != "")
            ''gtk-cursor-theme-name=${cfg.gtk.cursorTheme}''}
          gtk-fallback-icon-theme=gnome
          gtk-application-prefer-dark-theme=true
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintfull
          gtk-xft-rgba=none
        '';
        # GTK2 global theme (widget and icon theme)
        "gtk-2.0/gtkrc".text = ''
          ${optionalString (cfg.gtk.theme != "")
            ''gtk-theme-name="${cfg.gtk.theme}"''}
          ${optionalString (cfg.gtk.iconTheme != "")
            ''gtk-icon-theme-name="${cfg.gtk.iconTheme}"''}
          gtk-font-name="Sans ${toString(cfg.fonts.sans.size)}"
        '';
        # QT4/5 global theme
        "Trolltech.conf".text = ''
          [Qt]
          ${optionalString (cfg.gtk.theme != "")
            ''style=${cfg.gtk.theme}''}
        '';
      };

      fonts.fontconfig.defaultFonts = {
        sansSerif = [ cfg.fonts.sans.name ];
        monospace = [ cfg.fonts.mono.name ];
      };
    }

    (mkIf (cfg.onReload != { })
      (
        let
          reloadTheme =
            with pkgs; (writeScriptBin "reloadTheme" ''
              #!${stdenv.shell}
              echo "Reloading current theme: ${cfg.active}"
              ${concatStringsSep "\n"
                (mapAttrsToList (name: script: ''
                  echo "[${name}]"
                  ${script}
                '') cfg.onReload)}
            '');
        in
        {
          user.packages = [ reloadTheme ];
          system.userActivationScripts.reloadTheme = ''
            [ -z "$NORELOAD" ] && ${reloadTheme}/bin/reloadTheme
          '';
        }
      ))
  ]);
}

