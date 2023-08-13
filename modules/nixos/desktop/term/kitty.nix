{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.term.kitty;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.term.kitty = { enable = mkBoolOpt false; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kitty
    ];
    home.configFile = {
      "kitty" = {
        source = "${configDir}/kitty";
        recursive = true;
      };
    };
  };
}

