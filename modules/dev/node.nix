# modules/dev/node.nix --- https://nodejs.org/en/
#
# JS is one of those "when it's good, it's alright, when it's bad, it's a
# disaster" languages.
{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.node;
in
{
  options.modules.dev.node = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (
      mkIf cfg.enable {

        home.packages = with pkgs; with nodePackages; [
          # Package manager
          npm
          # Framework
          nodejs
        ];

      }
    )

    (mkIf cfg.xdg.enable {
      env.NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
      env.NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
      env.NPM_CONFIG_PREFIX = "$XDG_CACHE_HOME/npm";
      env.NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node/repl_history";

      home.configFile."npm/config".text = ''
        cache=$XDG_CACHE_HOME/npm
        prefix=$XDG_DATA_HOME/npm
      '';
    })
  ];
}
