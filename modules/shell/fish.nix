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
      my.icomoon # Font for starship config
      curl # For the gitignore command
      grc # Tex colourizer
    ];

    home.programs = {
      direnv.enable = true;
      direnv.nix-direnv.enable = true;
      # Fish shell

      fish = {
        enable = true;
        functions = {
          # Get rid of the annoying fish greeting
          "fish_greeting" = "";

          __fish_command_not_found_handler = {
            body = "command-not-found $argv[1]";
            onEvent = "fish_command_not_found";
          };

          # Get gitignore for specific project
          gitignore = "curl -sL https://www.gitignore.io/api/$argv > .gitignore";

        };


        plugins = [
          # Notify when a long process is done
          {
            name = "done";
            src = pkgs.fishPlugins.done.src;
          }
          # Duh, autopairs
          {
            name = "autopair";
            src = pkgs.fishPlugins.autopair-fish.src;
          }
          # Removes commands with errors and other thins from your fish history
          {
            name = "sponge";
            src = pkgs.fishPlugins.sponge.src;
          }
          # Removes commands with errors and other thins from your fish history
          {
            name = "colourizer";
            src = pkgs.fishPlugins.grc.src;
          }

        ];
      };

      # Exa (replacement for ls)
      exa = {
        enable = true;
        enableAliases = true;
      };

    };

    # Set the fish shell as default
    users.defaultUserShell = pkgs.fish;


  };
}
