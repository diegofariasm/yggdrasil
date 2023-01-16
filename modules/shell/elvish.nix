{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.elvish;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.elvish = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.elvish;

    home.packages = with pkgs; [
      my.icomoon # Starship font
    ];
    # Exa, the replacement for ls
    home.programs.exa.enable = true;
    # Starship config
    home.programs.starship = {
      enable = true;
    };
    # Direnv
    home.programs.direnv.enable = true;
    home.programs.direnv.nix-direnv.enable = true;
    # Protect nix-shell from garbage collection
    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    home.configFile = {
      "starship.toml".text = ''
                format = """
        [  $username$hostname ]\
        (bold bg:black fg:white)\
        []\
        (bold bg:purple fg:black)\
        [\
        $git_branch\
        $git_commit\
        $git_state\
        $git_metrics\
        $git_status\
        $hg_branch\
        ]\
        (bold bg:purple fg:black)\
        []\
        (bold bg:none fg:purple) \
        $hg_branch\
        $docker_context\
        $package\
        $cmake\
        $cobol\
        $dart\
        $deno\
        $dotnet\
        $elixir\
        $elm\
        $erlang\
        $golang\
        $helm\
        $java\
        $julia\
        $kotlin\
        $lua\
        $nim\
        $nodejs\
        $ocaml\
        $perl\
        $php\
        $pulumi\
        $purescript\
        $python\
        $rlang\
        $red\
        $ruby\
        $rust\
        $scala\
        $swift\
        $terraform\
        $vlang\
        $vagrant\
        $zig\
        $nix_shell\
        $conda\
        $memory_usage\
        $aws\
        $gcloud\
        $openstack\
        $env_var\
        $crystal\
        $line_break\
        [バカ](bold bg:none fg:white)\
        $singularity\
        $kubernetes\
        $directory\
        $status\
        $character\
        """
        # So there is no command timeout
        command_timeout = 10000

        [fill]
        symbol = " "

        [username]
        show_always = true
        style_user = "bold bg:black fg:white"
        style_root = "bold bg:black fg:white"
        format = "[$user]($style)"

        [hostname]
        ssh_only = true
        style = "bg:black fg:white"
        format = "[@$hostname]($style)"

        [git_branch]
        symbol = " "
        format = " on [$symbol$branch]($style) "
        style = "bold bg:purple fg:black"

        [git_commit]
        style = "bold bg:purple fg:black"

        [git_state]
        style = "bold bg:purple fg:black"

        [git_status]
        style = "bold bg:purple fg:black"

        [directory]
        read_only = " "
        truncation_length = 3
        truncation_symbol = "./"
        style = "bold bg:none fg:yellow"

        [status]
        disabled = false
        symbol = '✗'

        [line_break]
        disabled = false

        [character]
        success_symbol = "[  ](bold white)"
        error_symbol = "[  ](bold red)"
        vicmd_symbol = "[  ](bold yellow)"

       
      '';
    };

  };

}
