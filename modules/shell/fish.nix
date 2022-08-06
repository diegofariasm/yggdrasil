{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.fish;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.fish = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fasd # Necessary for plugin
    ];

    home.programs.exa = {
      enable = true;
      enableAliases = true;
    };

    home.programs.starship = {
      enable = true;
      enableFishIntegration = true;

    };
    programs.fish.enable = true;
    home.programs.fish = {
      enable = true;
    functions = {
            fish_greeting = "";

        };
    };

    users.defaultUserShell = pkgs.fish;
  };
}
