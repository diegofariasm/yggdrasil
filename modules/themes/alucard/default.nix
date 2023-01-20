# modules/themes/alucard/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in
{
  config = mkIf (cfg.active == "alucard") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          gtk = {
            theme = "Dracula";
            iconTheme = "Paper";
            cursorTheme = "Paper";
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
        paper-icon-theme # for rofi
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


      home.configFile = {
        "Dracula-purple-solid-kvantum" = {
          recursive = true;
          source = "${pkgs.unstable.dracula-theme}/share/themes/Dracula/kde/kvantum/Dracula-purple-solid";
          target = "Kvantum/Dracula-purple-solid";
        };
        "kvantum.kvconfig" = {
          text = "theme=Dracula-purple-solid";
          target = "Kvantum/kvantum.kvconfig";
        };

      };


    })
  ]);
}

