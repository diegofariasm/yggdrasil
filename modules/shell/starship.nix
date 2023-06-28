{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.starship;
in
{
  options.modules.shell.starship = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      starship
    ];

    # Needed font for the icons
    fonts.fonts = with pkgs; with my; [
      icomoon
    ];

    # Packages needed by the module
    home.configFile = {
      "starship.toml".text = ''
        command_timeout = 100000

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
        ]\
        (bold bg:purple fg:black)\
        []\
        (bold bg:none fg:purple) \
        $nix_shell\
        $memory_usage\
        $env_var\
        $line_break\
        [バカ](bold bg:none fg:white)\
        $directory\
        $status\
        $character
        """

        [fill]
        symbol = " "

        [username]
        show_always = true
        format = "[$user]($style)"
        style_user = "bold bg:black fg:white"
        style_root = "bold bg:black fg:white"

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
        error_symbol = "[  ](bold red)"
        vicmd_symbol = "[  ](bold yellow)"
        success_symbol = "[  ](bold white)"
      '';
    };
    modules.shell.zsh.rcInit = ''eval "$(starship init zsh)"'';
  };
}
