{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.neofetch;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.apps.neofetch = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      neofetch
      chafa
    ];

    home.configFile."neofetch" = {
      source = "${configDir}/neofetch";
      recursive = true;
    };
  };
}
