# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.
{ config
, options
, lib
, pkgs
, inputs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.vim;
  configDir = config.dotfiles.configDir;
in
{

  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    home.programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;

      # Setting the aliases
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    home.packages = with pkgs; [
      # Utils needed by nyoom
      tree-sitter
      # Formatters for the nvim config
      fnlfmt
      # Utils needed by plugins 
      ripgrep
      fzf
      # Languages
      lua
      # Language servers 
      rnix-lsp
      sumneko-lua-language-server
      # Linters
      selene
    ];


    # adds the nyoom bin to the shell path
    env.PATH = [ "$HOME/.config/nvim/bin" ];

  };
}
