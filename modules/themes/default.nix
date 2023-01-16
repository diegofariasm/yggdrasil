# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
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


    gtk = {
      theme = mkOpt str "";
      iconTheme = mkOpt str "";
      cursorTheme = mkOpt str "";
    };

    onReload = mkOpt (attrsOf lines) { };

    fonts = {
      # TODO Use submodules
      mono = {
        name = mkOpt str "Monospace";
        size = mkOpt int 12;
      };
      sans = {
        name = mkOpt str "Sans";
        size = mkOpt int 10;
      };
    };

  };

  config = mkIf (cfg.active != null) (mkMerge [

    {
      programs.dconf.enable = true;
     
      fonts.fontconfig.defaultFonts = {
        sansSerif = [ cfg.fonts.sans.name ];
        monospace = [ cfg.fonts.mono.name ];
      };
    }



  ]);
}
