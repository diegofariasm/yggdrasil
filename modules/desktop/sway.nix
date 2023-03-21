{ pkgs
, config
, inputs
, lib
, options
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.sway;
  configDir = config.dotfiles.configDir;
  theme = config.modules.theme;
  # Sway scripts
  swayPath = "${config.user.home}/.config/sway";
  swayBinPath = "${config.user.home}/.config/sway/bin";
  swayc = "exec ${pkgs.ruby}/bin/ruby ${swayPath}/bin/main.rb";
in
{
  options.modules.desktop.sway = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    programs.sway.enable = true;
    maiden.wayland.windowManager.sway = {
      enable = true;
      package = pkgs.sway;
      # Adds sway-session.target
      systemdIntegration = true;
      # Proper GTK 
      wrapperFeatures.gtk = true;
      config = {
        startup = [
          {
            # Open the bars
            command = "${pkgs.eww-wayland}/bin/eww open bar && ${pkgs.eww-wayland}/bin/eww open bar2";
            always = false;
          }
          {
            # Update the eww bar
            command = "${swayc} --update-modules";
            always = true;
          }
          {
            # Set wallpaper
            command = "${pkgs.swaybg}/bin/swaybg -i ${config.user.home}/.config/sway/wallpapers/cell_od11.png";
            always = false;
          }
        ];
        seat."*".hide_cursor = "when-typing disable";
        input = {
          "keyboard" = {
            xkb_layout = "br";
            xkb_options = "caps:super";
            repeat_rate = "300";
            repeat_delay = "20";
          };
          "type:mouse" = {
            dwt = "disabled";
            accel_profile = "flat";
          };
          "type:touchpad" = {
            tap = "enabled";
            accel_profile = "adaptive";
            scroll_factor = "0.45";
            pointer_accel = "0.32";
            natural_scroll = "enabled";
          };
        };
        # Disable defalt bar
        bars = [ ];
        # Gaps
        gaps = {
          outer = 5;
          inner = 5;
        };
        defaultWorkspace = "workspace 1";
        keybindings =
          let
            modifier = "Mod4";
            concatAttrs = lib.fold (x: y: x // y) { };
            tagBinds =
              concatAttrs
                (map
                  (i: {
                    "${modifier}+${toString i}" = "exec 'swaymsg workspace ${toString i} && ${pkgs.eww-wayland}/bin/eww update active-tag=${toString i}'";
                    "${modifier}+Shift+${toString i}" = "exec 'swaymsg move container to workspace ${toString i}'";
                  })
                  (lib.range 0 9));
          in
          tagBinds
          // {
            "${modifier}+Return" = "exec ${pkgs.foot}/bin/foot";
            "${modifier}+d" = "exec ${swayBinPath}/runner";

            # Brightness
            "XF86MonBrightnessDown" = "${swayc} --decrease-brightness 5";
            "XF86MonBrightnessUp" = "${swayc} --increase-brightness 5";
            # Volume
            "XF86AudioMute" = "${swayc} --toggle-mute";
            "XF86AudioLowerVolume" = "${swayc} --decrease-volume 5";
            "XF86AudioRaiseVolume" = "${swayc} --increase-volume 5";


            "${modifier}+c" = "kill";
            "${modifier}+r" = ''mode "resize"'';
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";
            "${modifier}+f" = "fullscreen";
            "${modifier}+space" = "floating toggle";
            "${modifier}+Shift+s" = "sticky toggle";
            "${modifier}+Shift+space" = "focus mode_toggle";
            "${modifier}+a" = "focus parent";
            "${modifier}+Shift+r" = "reload";
            "${modifier}+Shift+q" = "exit";
          };
        colors = with config.lib.base16.theme; {
          focused = {
            background = "#${base05-hex}";
            indicator = "#${base05-hex}";
            border = "#${base05-hex}";
            text = "#${base05-hex}";
            childBorder = "#${base05-hex}";
          };
          focusedInactive = {
            background = "#${base01-hex}";
            indicator = "#${base01-hex}";
            border = "#${base01-hex}";
            text = "#${base01-hex}";
            childBorder = "#${base01-hex}";
          };
          unfocused = {
            background = "#${base01-hex}";
            indicator = "#${base01-hex}";
            border = "#${base01-hex}";
            text = "#${base01-hex}";
            childBorder = "#${base01-hex}";
          };
          urgent = {
            background = "#${base0A-hex}";
            indicator = "#${base0A-hex}";
            border = "#${base0A-hex}";
            text = "#${base0A-hex}";
            childBorder = "#${base0A-hex}";
          };
        };
      };
      extraConfig = ''
        # Use proper gtk theming
        set $schema "org.gnome.desktop.interface"
        exec_always {
            gsettings set $schema gtk-theme ${theme.gtk.theme}
            gsettings set $schema icon-theme ${theme.gtk.iconTheme}
            gsettings set $schema cursor-theme ${theme.gtk.cursorTheme}
        }
       
        default_border none
        default_floating_border none
      
        # gestures
        bindgesture swipe:3:right workspace prev
        bindgesture swipe:3:left workspace next
        bindgesture swipe:3:up exec ${pkgs.sov}/bin/sov
        # bind workspaces 1-9 to main output
        workspace 1 output eDP-1
        workspace 2 output eDP-1
        workspace 3 output eDP-1
        workspace 4 output eDP-1
        workspace 5 output eDP-1
        workspace 6 output eDP-1
        workspace 7 output eDP-1
        workspace 8 output eDP-1
        workspace 9 output eDP-1
      '';
    };

    fonts.fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Iosevka"
          "SourceCodePro"
          "Hack"
          "Meslo"
        ];
      })
    ];

    home = {
      packages = with pkgs; [
        foot
        swaybg
        eww-wayland
        glib
      ];

      configFile = {
        "eww/eww.yuck".text = ''
          (defwidget bar []
            (centerbox :orientation "v"
                       :halign "center"
              (box :class "segment-top"
                   :valign "start"
                   :orientation "v"
                (tags)) (box :class "segment-center"
                   :valign "center"
                   :orientation "v"
                (time)
                (date))
              (box :class "segment-bottom"
                   :valign "end"
                   :orientation "v"
                (menu)
                (brightness)
                (volume)
                (battery)
                (current-tag))))

          (defwidget time []
            (box :class "time"
                 :orientation "v"
              hour min type))

          (defwidget date []
            (box :class "date"
                 :orientation "v"
                day month year))

          (defwidget menu []
            (button :class "icon"
                    :orientation "v"
                    :onclick "''${EWW_CMD} open --toggle notifications-menu"
               ""))

          (defwidget brightness []
            (button :class "icon"
                    :orientation "v"
              (circular-progress :value brightness-level
                                 :thickness 3)))

          (defwidget volume []
            (button :class "icon"
                    :orientation "v"
              (circular-progress :value volume-level
                                 :thickness 3)))

          (defwidget battery []
            (button :class "icon"
                    :orientation "v"
                    :onclick ""
              (circular-progress :value "''${EWW_BATTERY['BAT1'].capacity}"
                                 :thickness 3)))

          (defwidget current-tag []
            (button :class "current-tag"
                    :orientation "v"
                    :onclick "${swayBinPath}/runner & disown"
              "''${active-tag}"))

          (defvar active-tag "1")
          (defpoll hour :interval "1m" "date +%I")
          (defpoll min  :interval "1m" "date +%M")
          (defpoll type :interval "1m" "date +%p")

          (defpoll day   :interval "10m" "date +%d")
          (defpoll month :interval "1h"  "date +%m")
          (defpoll year  :interval "1h"  "date +%y")

          ;; this is updated by the helper script
          (defvar brightness-level 66)
          (defvar volume-level 33)

            (defwidget tags []
              (box :class "tags"
                   :orientation "v"
                   :halign "center"
                (for tag in tags
                  (box :class {active-tag == tag.tag ? "active" : "inactive"}
                    (button :onclick "swaymsg workspace ''${tag.tag} ; ''${EWW_CMD} update active-tag=''${tag.tag}"
                      "''${tag.label}")))))

            (defvar tags '[{ "tag": 1, "label": "一" },
                           { "tag": 2, "label": "二" },
                           { "tag": 3, "label": "三" },
                           { "tag": 4, "label": "四" },
                           { "tag": 5, "label": "五" },
                           { "tag": 6, "label": "六" },
                           { "tag": 7, "label": "七" },
                           { "tag": 8, "label": "八" },
                           { "tag": 9, "label": "九" },
                           { "tag": 0, "label": "rM" }]')


          (defwindow bar
            :monitor 0
            :stacking "bottom"
            :geometry (geometry
                        :height "100%"
                        :anchor "left center")
            :exclusive true
            (bar))

          (defwindow bar2
            :monitor 1
            :stacking "bottom"
            :geometry (geometry
                        :height "100%"
                        :anchor "left center")
            :exclusive true
            (bar))
        '';
        "eww/eww.scss".text = with config.lib.base16.theme; ''
          $baseTR: rgba(13,13,13,0.13);
          $base00: #${baseBLEND-hex};
          $base01: #${base01-hex};
          $base02: #${base02-hex};
          $base03: #${base03-hex};
          $base04: #${base04-hex};
          $base05: #${base05-hex};
          $base06: #${base06-hex};
          $base07: #${base07-hex};
          $base08: #${base08-hex};
          $base09: #${base09-hex};
          $base0A: #${base0A-hex};
          $base0B: #${base0B-hex};
          $base0C: #${base0C-hex};
          $base0D: #${base0D-hex};
          $base0E: #${base0E-hex};
          $base0F: #${base0F-hex};
          $baseIBM: #${baseIBM-hex};

                  * {
                    all: unset;
                  }

                  window {
                    font-family: "Liga SFMono Nerd Font";
                    font-size: 13px;
                    background-color: rgba(0, 0, 0, 0);
                    color: $base04;

                    &>* {
                      margin: 0px 0px 12px 12px;
                    }
                  }

                  .tags {
                    margin-top: 9px;
                  }

                  .active {
                    color: $base06;
                    padding: 6px 9px 6px 6px;
                    background-color: $baseTR;
                    border-left: 3px solid $base0D;

                  }

                  .segment-center {
                    margin-top: 18px;
                    padding: 9px;
                  }

                  .time {
                    color: $base06;
                    font-weight: bolder;
                    font-size: 16px;
                    margin-bottom: 6px;
                  }

                  .date {
                    margin-top: 6px;
                    font-weight: bolder;
                    font-size: 16px;
                  }

                  .icon {
                    background-color: $base00;
                    padding: 9px;
                    margin: 4.5px 0px;
                    border-radius: 3px;
                    font-size: 16px;
                    font-weight: bolder;
                  }

                  .current-tag {
                    color: $base00;
                    background-color: $base0E;
                    padding: 9px;
                    margin: 4.5px 0px;
                    border-radius: 3px;
                  }
        '';
        "sway" = {
          source = "${configDir}/sway";
          recursive = true;
        };
      };
    };
  };
}
