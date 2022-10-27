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
    ];

    home.programs.exa = {
      enable = true;
      enableAliases = true;
    };

    home.programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };
    home.configFile = {
      "starship.toml".text = ''

format = """
[  $username ]\
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
$fill\
$line_break\
(bold bg:white fg:yellow)\
[バカ](bold bg:none fg:white)\
$singularity\
$kubernetes\
$directory\
$status\
$character
"""

[fill]
symbol = " "

[username]
show_always = true
style_user = "bold bg:black fg:white"
style_root = "bold bg:black fg:white"
format = "[$user]($style)"

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

[line_break]
disabled = false

[character]
success_symbol = "[  ](bold white)"
error_symbol = "[  ](bold red)"
vicmd_symbol = "[  ](bold yellow)"
    '';
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
