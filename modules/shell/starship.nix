{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.starship;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.starship = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf config.modules.shell.fish.enable {
      home.programs.starship = {
        enable = true;
        enableFishIntegration = true;
      };
    })
  ]);
}
