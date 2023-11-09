# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.theme;
in
{
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      apply = v:
        let theme = builtins.getEnv "THEME";
        in if theme != "" then theme else v;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable. Themes can also be hot-swapped with 'hey theme $THEME'.
      '';
    };

    wallpaper = mkOpt (either path null) null;

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
      # Don't auto enable targets.
      # This makes sure that i am the one to theme
      # my apps, while stylix provies me with help to do so.
      autoEnable = false;
      # These are targets that need somethings to work properly.
      # So, with that, we actually theme it through nixos / home-manager.
      targets = {
        gtk = {
          enable = true;
        };
      };
    };

  };
}
