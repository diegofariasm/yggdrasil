{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  configDir = config.dotfiles.configDir;
  cfg = config.modules.desktop.term.wezterm;
in
{
  options.modules.desktop.term.wezterm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wezterm
    ];
    home.configFile = {
      "wezterm" = {
        recursive = true;
        source = "${configDir}/wezterm";
      };
    };
  };
}
