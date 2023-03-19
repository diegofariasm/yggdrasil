# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.
{ options, inputs, config, lib, pkgs, ... }:
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
      themes.base16 = {
        enable = true;
        path = "${inputs.base16-oxocarbon}/base16-oxocarbon-dark.yaml";
      };

      home = {
        file = {
          ".Xresources".text = ''
            ! ! Automatically generated. Do not edit.                                                                    
            ! ! Oxocarbon
                                                                    
            ! scheme: "Oxocarbon Dark"
            ! author: "shaunsingh/IBM"
                                                                    
            #define st00 #161616
            #define st01 #262626
            #define st02 #393939
            #define st03 #525252
            #define st04 #dde1e6
            #define st05 #f2f4f8
            #define st06 #ffffff
            #define st07 #08bdba
            #define st08 #3ddbd9
            #define st09 #78a9ff
            #define st0A #ee5396
            #define st0B #33b1ff
            #define st0C #ff7eb6
            #define st0D #42be65
            #define st0E #be95ff
            #define st0F #82cfff
                                                                    
            st.foreground:   st05
            #ifdef background_opacity
            st.background:   [background_opacity]st00
            #else
            st.background:   st00
            #endif
            st.cursorColor:  st05
                                                                    
            st.color0:       st00
            st.color1:       st08
            st.color2:       st0B
            st.color3:       st0A
            st.color4:       st0D
            st.color5:       st0E
            st.color6:       st0C
            st.color7:       st05
                                                                    
            st.color8:       st03
            st.color9:       st09
            st.color10:      st01
            st.color11:      st02
            st.color12:      st04
            st.color13:      st06
            st.color14:      st0F
            st.color15:      st07

            ! ! Theme other apps
            #include "${config.user.home}/.config/dwm/dwm_xresources/colors"
          '';
        };
        configFile = {
          "gtk-4.0/settings.ini".text = ''
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

          # GTK 3
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
        };
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

