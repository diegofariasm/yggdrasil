# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.neovim;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.neovim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      lua
      unstable.neovim
      gcc
      fd
    ];

    # home.configFile."nvim" = {
    #   source = "${configDir}/nvim";
    #   recursive = true;
    # };

    # This is for non-neovim, so it loads my nvim config
    # env.VIMINIT = "let \\$MYVIMRC='\\$XDG_CONFIG_HOME/nvim/init.vim' | source \\$MYVIMRC";

    environment.shellAliases = {
      vim = "nvim";
      v = "nvim";
    };
  };
}
