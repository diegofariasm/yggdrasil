# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.theme;
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

    isLight = mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = ''
        Wheter to enable either the light version of the theme.
      '';
    };

    # Options to the gtk theming.
    # Note: theme is not here because
    # there are other tools already doing that job.
    gtk = {
      iconTheme = {
        name = mkOpt str "Papirus";
        package = mkOpt package pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = mkOpt str "Nordzy-white-cursors";
        package = mkOpt package pkgs.nordzy-cursor-theme;
      };
    };

    # Note: this wallpaer is used by stlix
    # to generate the rest of the theming.
    wallpaper = mkOpt (either path null) null;

  };

  config = mkIf (cfg.active != null) {

    # A nice icon theme is always needed.
    # Not the best around, but for sure better than adwaita.
    gtk = {
      enable = true;
      iconTheme = {
        name = cfg.gtk.iconTheme.name;
        package = cfg.gtk.iconTheme.package;
      };
      cursorTheme = {
        name = cfg.gtk.cursorTheme.name;
        package = cfg.gtk.cursorTheme.package;
      };
    };



    stylix = {
      # Generate the colorschme from the image
      # Note: i am not currently using this to generate
      # the themes, i am just passing the base16 themes by myself.
      image = cfg.wallpaper;

      # Font configuration for the desktop.
      # I don't have a option for this, as i don't
      # change the fonts based on the theme anyway.
      fonts = {
        serif = {
          package = pkgs.julia-mono;
          name = "JuliaMono";
        };
        sansSerif = {
          package = pkgs.julia-mono;
          name = "JuliaMono";
        };
        monospace = {
          package = pkgs.julia-mono;
          name = "JuliaMono";
        };
        sizes = {
          popups = 12;
          desktop = 11;
          terminal = 14;
          applications = 11;
        };
      };
    };
  };
}
