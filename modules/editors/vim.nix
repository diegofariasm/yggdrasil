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
    user.packages = with pkgs; [
      neovim
    ];
    env.PATH = [
      ".config/nvim/bin"
    ];

    home.mutableFile = {
      ".config/nvim" = {
        url = "https://github.com/nyoom-engineering/nyoom.nvim";
        type = "git";
      };
    };

    # TODO: automatically install nyoom
    # system.userActivationScripts = mkIf cfg.nvim.enable {
    #   installNyoom = ''
    #   '';
    # };

  };
}
