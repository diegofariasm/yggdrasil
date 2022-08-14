# modules/themes/nordic/default.nix --- a nord inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "nordic") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          gtk = {
            theme = "Dracula";
            iconTheme = "Whitesur";
            cursorTheme = "Whitesur";
          };
          fonts = {
            sans.name = "Fira Sans";
            mono.name = "Fira Code";
          };

        };

        # shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        # shell.tmux.rcFiles = [ ./config/tmux.conf ];

      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {

      user.packages = with pkgs; [
        unstable.dracula-theme
        whitesur-gtk-theme
        whitesur-icon-theme

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
          blur-background = true;
          blur-background-frame = true;
          blur-background-fixed = true;
          blur-kern = "7x7box";
          blur-strength = 900;
        };
      };

    })
  ]);
}
