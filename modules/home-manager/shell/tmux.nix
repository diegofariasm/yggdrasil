{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.tmux;
in
{
  options.modules.shell.tmux = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable the tmux package for the shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      tmux = {
        enable = true;
        escapeTime = 0;

        plugins = with pkgs; with tmuxPlugins; [
          vim-tmux-navigator
          vim-tmux-focus-events
        ];

        extraConfig = ''
          unbind C-b
          set -g prefix C-c
          bind C-c send-prefix
                    	   
          bind c new-window      -c "#{pane_current_path}"
          bind v split-window -h -c "#{pane_current_path}"
          bind s split-window -v -c "#{pane_current_path}"

          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          bind o resize-pane -Z
          bind S choose-session
          bind W choose-window
          bind / choose-session
          bind . choose-window

          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind -T copy-mode-vi Escape send-keys -X cancel
          bind -T copy-mode-vi C-g send-keys -X cancel
          bind -T copy-mode-vi H send-keys -X start-of-line
          bind -T copy-mode-vi L send-keys -X end-of-line

          bind x kill-pane
          bind X kill-window
          bind q kill-session
          bind Q kill-server

          bind C-w last-pane
          bind C-n next-window
          bind C-p previous-window

          bind = select-layout even-vertical
          bind + select-layout even-horizontal
          bind - break-pane
          bind _ join-pane
        '';

      };
    };
    home.packages = with pkgs; [ tmux ];
  };
}
