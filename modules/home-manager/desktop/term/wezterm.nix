{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.term.wezterm;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.term.wezterm = {
    enable = lib.mkOption {
      description = ''
        Wheter to install wezterm.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      wezterm = {
        enable = true;
        extraConfig =
          ''
            return {
              window_padding = {
               left = 16, right = 16, top = 16, bottom = 16 
               },
                  window_close_confirmation = "NeverPrompt",
                  tab_max_width = 25,

                  show_tab_index_in_tab_bar = false,
                  hide_tab_bar_if_only_one_tab = true,
                  exit_behavior = "Close",
               }
          '';

      };
    };

    home = {
      packages = with pkgs; [
        wezterm
      ];
    };

  };
}
