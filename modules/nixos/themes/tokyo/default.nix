# modules/themes/alucard/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in
{
  config = mkIf (cfg.active == "tokyo") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          gtk = {
            theme = "Tokyonight-Moon-B";
            iconTheme = "Zafiro-icons-Dark";
            cursorTheme = "volantes_cursors";
          };
          fonts = {
            sans.name = "Fira Sans";
            mono.name = "Fira Code";
          };

        };

        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        shell.tmux.rcFiles = [ ./config/tmux.conf ];

      };
    }
    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      home.packages = with pkgs; [
        zafiro-icons
        tokyo-night-gtk
        volantes-cursors
      ];

    })
  ]);
}

