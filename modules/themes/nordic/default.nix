# modules/themes/alucard/default.nix --- a regal dracula-inspired theme
{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.theme;
in
{
  config = mkIf (cfg.active == "nordic") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          gtk = {
            theme = "Nordic";
            iconTheme = "Tela";
            cursorTheme = "Tela";
          };
          fonts = {
            sans.name = "Fira Sans";
            mono.name = "Fira Code";
          };

        };

        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        shell.tmux.rcFiles = [ ./config/tmux.conf ];

        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile [
            ./config/firefox/userChrome.css
          ];
          qutebrowser.userStyles =
            concatMapStringsSep "\n" readFile
              (map toCSSFile [
                ./config/qutebrowser/userstyles/monospace-textareas.scss
                ./config/qutebrowser/userstyles/stackoverflow.scss
                ./config/qutebrowser/userstyles/xkcd.scss
              ]);
        };
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      home.packages = with pkgs; [
        unstable.nordic
        tela-icon-theme # for rofi
      ];
      fonts = {
        fonts = with pkgs; [
          fira-code
          fira-code-symbols
          open-sans
          jetbrains-mono
          siji
          font-awesome
        ];
      };

      # Compositor
      services.picom = {
        fade = true;
        fadeDelta = 1;
        fadeSteps = [ 0.01 0.012 ];
        shadow = true;
        shadowOffsets = [ (-10) (-10) ];
        shadowOpacity = 0.22;
        # activeOpacity = "1.00";
        # inactiveOpacity = "0.92";
        settings = {
          shadow-radius = 12;
          # blur-background = true;
          # blur-background-frame = true;
          # blur-background-fixed = true;
          blur-kern = "7x7box";
          blur-strength = 320;
        };
      };

      # Login screen theme
      services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
        text-color = "${cfg.colors.magenta}"
        password-background-color = "${cfg.colors.black}"
        window-color = "${cfg.colors.types.border}"
        border-color = "${cfg.colors.types.border}"
      '';

      # Other dotfiles
      home.configFile = with config.modules;
        mkMerge [
          {
            # Sourced from sessionCommands in modules/themes/default.nix
            "xtheme/90-theme".source = ./config/Xresources;
          }
          (mkIf desktop.bspwm.enable {
            "bspwm/rc.d/00-theme".source = ./config/bspwmrc;
            "bspwm/rc.d/95-polybar".source = ./config/polybar/run.sh;
          })
          (mkIf desktop.apps.rofi.enable {
            "rofi/theme" = {
              source = ./config/rofi;
              recursive = true;
            };
          })
          (mkIf (desktop.bspwm.enable || desktop.stumpwm.enable) {
            "polybar" = {
              source = ./config/polybar;
              recursive = true;
            };
            "dunst/dunstrc".text = import ./config/dunstrc cfg;
            "Dracula-purple-solid-kvantum" = {
              recursive = true;
              source = "${pkgs.unstable.dracula-theme}/share/themes/Dracula/kde/kvantum/Dracula-purple-solid";
              target = "Kvantum/Dracula-purple-solid";
            };
            "kvantum.kvconfig" = {
              text = "theme=Dracula-purple-solid";
              target = "Kvantum/kvantum.kvconfig";
            };
          })
          (mkIf desktop.media.graphics.vector.enable {
            "inkscape/templates/default.svg".source = ./config/inkscape/default-template.svg;
          })
          (mkIf desktop.browsers.qutebrowser.enable {
            "qutebrowser/extra/theme.py".source = ./config/qutebrowser/theme.py;
          })
        ];
    })
  ]);
}
