{ config, lib, ... }:

let
  cfg = config.modules.shell.zsh;
in
{
  options.modules.shell.zsh = {
    enable = lib.mkOption {
      description = ''
        Wheter to install zsh.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    # Note: this is temporary.
    # I am currently using this because
    # i haven't figured out yet how to add
    # user variables to my other shells.
    programs.zsh = {
      enable = true;

      # GET OUT OF MY $HOME
      dotDir = ".config/zsh";

      # Package manager
      antidote = {
        enable = true;
        useFriendlyNames = true;

        # A list of curated plugins.
        plugins = [
          "unixorn/fzf-zsh-plugin"
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting"
          "zsh-users/zsh-history-substring-search"
        ];

      };
      history = {
        # Share zsh history between sessions
        # This is really nice.
        share = true;
        ignoreSpace = true;
      };
    };

  };
}