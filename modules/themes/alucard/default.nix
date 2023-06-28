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
            cursorTheme = "Dracula-cursors";
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

      user.packages = with pkgs; [
        dracula-theme
        paper-icon-theme
      ];

    })
  ]);
}

