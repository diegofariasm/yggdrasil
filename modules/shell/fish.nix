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
      # Fish shell

      fish = {
        enable = true;
        functions = {
          # Get rid of the annoying fish greeting
          "fish_greeting" = "";

          __fish_command_not_found_handler = {
            body = "__fish_default_command_not_found_handler $argv[1]";
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

      # Shell independent prompt
      starship = {
        enable = true;
        enableFishIntegration = true;
      };
    };

    # Set the fish shell as default
    users.defaultUserShell = pkgs.fish;

    # add $HOME/.bin to path
    env.PATH = [ "$HOME/.bin" ];

    # Config for the starship prompt
    #    home.configFile = {
    #      "starship.toml".text = ''
    #        format = """
    #        [  $username ]\
    #        (bold bg:black fg:white)\
    #        []\
    #        (bold bg:purple fg:black)\
    #        [\
    #        $git_branch\
    #        $git_commit\
    #        $git_state\
    #        $git_metrics\
    #        $git_status\
    #        $hg_branch\
    #        ]\
    #        (bold bg:purple fg:black)\
    #        []\
    #        (bold bg:none fg:purple) \
    #        $hg_branch\
    #        $docker_context\
    #        $package\
    #        $cmake\
    #        $cobol\
    #        $dart\
    #        $deno\
    #        $dotnet\
    #        $elixir\
    #        $elm\
    #        $erlang\
    #        $golang\
    #        $helm\
    #        $java\
    #        $julia\
    #        $kotlin\
    #        $lua\
    #        $nim\
    #        $nodejs\
    #        $ocaml\
    #        $perl\
    #        $php\
    #        $pulumi\
    #        $purescript\
    #        $python\
    #        $rlang\
    #        $red\
    #        $ruby\
    #        $rust\
    #        $scala\
    #        $swift\
    #        $terraform\
    #        $vlang\
    #        $vagrant\
    #        $zig\
    #        $nix_shell\
    #        $conda\
    #        $memory_usage\
    #        $aws\
    #        $gcloud\
    #        $openstack\
    #        $env_var\
    #        $crystal\
    #        $fill\
    #        $line_break\
    #        (bold bg:white fg:yellow)\
    #        [バカ](bold bg:none fg:white)\
    #        $singularity\
    #        $kubernetes\
    #        $directory\
    #        $status\
    #        $character
    #        """
    #
    #        [fill]
    #        symbol = " "
    #
    #        [username]
    #        show_always = true
    #        style_user = "bold bg:black fg:white"
    #        style_root = "bold bg:black fg:white"
    #        format = "[$user]($style)"
    #
    #        [git_branch]
    #        symbol = " "
    #        format = " on [$symbol$branch]($style) "
    #        style = "bold bg:purple fg:black"
    #
    #        [git_commit]
    #        style = "bold bg:purple fg:black"
    #
    #        [git_state]
    #        style = "bold bg:purple fg:black"
    #
    #        [git_status]
    #        style = "bold bg:purple fg:black"
    #
    #        [directory]
    #        read_only = " "
    #        truncation_length = 3
    #        truncation_symbol = "./"
    #        style = "bold bg:none fg:yellow"
    #
    #        [status]
    #        disabled = false
    #
    #        [line_break]
    #        disabled = false
    #
    #        [character]
    #        success_symbol = "[  ](bold white)"
    #        error_symbol = "[  ](bold red)"
    #        vicmd_symbol = "[  ](bold yellow)"
    #      '';
    #    };

  };
}
