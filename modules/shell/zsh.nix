{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.zsh;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.zsh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;
    home.packages = with pkgs; [
      my.icomoon
      # Rsync  module
      rsync
    ];
    programs.zsh.enable = true;
    home.programs = {
      exa = {
        enable = true;
        enableAliases = true;
      };
      starship = {
        enable = true;
        enableZshIntegration = true;
      };
      zsh = {
        enable = true;
        # History config
        history = {
          save = 10000;
          ignoreDups = true;
          ignoreSpace = true;
        };
        # Config location
        dotDir = ".config/zsh";

        # Prezto config
        prezto = {
          enable = true;
          # Case insensitive completion
          caseSensitive = false;
          # Autoconvert .... to ../..
          editor.dotExpansion = true;
          # Prezto modules to load

          pmodules = [
            "rsync"
            "archive"
            "completion"
            "syntax-highlighting"
            "history-substring-search"
            "autosuggestions"
          ];
        };
        # Plugin configuration      
        plugins = [
          {
            name = "zsh-autopair";
            file = "autopair.zsh";
            src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair/";
          }

        ];
      };
    };

    home.configFile = {
      "starship.toml".text = ''
        format = """
        (bold bg:white fg:yellow)\
        [バカ](bold bg:none white)\
        $singularity\
        $kubernetes\
        $directory\
        $status\
        $character\
        """

        # So commands don't time out. Duh?
        command_timeout = 100000
        [fill]
        symbol = ""

        [username]
        show_always = true
        style_user = "bold bg:#202023 fg:white"
        style_root = "bold bg:#202023 fg:white"
        format = "[$user]($style)"


        [directory]
        read_only = ""
        truncation_length = 3
        truncation_symbol = "./"
        style = "bold bg:none yellow"

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
  };
}
