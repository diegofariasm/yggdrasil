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

  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      emacs
    ];
    # TODO: find way of using the icons from the icomoon font with this.
    # fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    env.PATH = [
      ".config/emacs/bin"
    ];

    maiden.home.mutableFile = {
      ".config/emacs" = {
        url = "https://github.com/doomemacs/doomemacs";
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
