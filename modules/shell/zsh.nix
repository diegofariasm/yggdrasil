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
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
      };
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

  };
}
