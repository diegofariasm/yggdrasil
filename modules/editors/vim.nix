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

    home.packages = with pkgs; [
      neovim
      selene
      marksman
      lua-language-server
    ];

    # adds the nyoom bin to the shell path
    env.PATH = [
      "$HOME/.config/nvim/bin"
    ];

  };
}
