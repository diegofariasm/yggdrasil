{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.term.kitty;
in
{
  options.modules.desktop.term.kitty = { enable = mkBoolOpt false; };
  config = mkIf cfg.enable {

    maiden.programs.kitty = {
      enable = true;

      font = {
        name = "Jetbrains Mono";
        size = 14;
        package = pkgs.jetbrains-mono;
      };

      keybindings =
        let
          kitty_mod = "alt";
          alt_kitty_mod = "ctrl";
        in
        {
          "${kitty_mod}+c" = "copy_to_clipboard";
          "${kitty_mod}+v" = "paste_from_clipboard";

          "${kitty_mod}+t" = "new_tab";
          "${kitty_mod}+w" = "close_tab";

          "${alt_kitty_mod}+c" = "interrupt";
          "${alt_kitty_mod}+v" = "nvim";
        };

      settings = {
        scrollback_lines = 1000;
        enable_audio_bell = false;
        confirm_os_window_close = 0;

        # Theming
        window_padding_width = 4;


        cursor = "#4a4a4a";
        cursor_text_color = "#d4be98";
        cursor_shape = "block";

        mouse_hide_wait = 1;
        url_color = "#f5369c";
        url_style = "curly";
        open_url_with = "default";

        foreground = "#d4be98";
        background = "#282828";
        background_opacity = "0.8";

        # = Black = + = DarkGrey;
        color0 = "#32302f";
        color8 = "#32302f";
        # = DarkRed = + = Red;
        color1 = "#ea6962";
        color9 = "#ea6962";
        # = DarkGreen = + = Green;
        color2 = "#a9b665";
        color10 = "#a9b665";
        # = DarkYellow = + = Yellow;
        color3 = "#e78a4e";
        color11 = "#e78a4e";
        # = DarkBlue = + = Blue;
        color4 = "#7daea3";
        color12 = "#7daea3";
        # = DarkMagenta = + = Magenta;
        color5 = "#d3869b";
        color13 = "#d3869b";
        # = DarkCyan = + = Cyan;
        color6 = "#89b482";
        color14 = "#89b482";
        # = LightGrey = + = White;
        color7 = "#d4be98";
        color15 = "#d4be98";

      };
    };
  };
}

