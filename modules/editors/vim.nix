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
    nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ];

    home.packages = with pkgs;
      [
        neovim-unwrapped

        # -- Language Servers  -- #
        rnix-lsp

      ];

    home.configFile."nvim" = {
      source = builtins.fetchTarball {
        url = "https://github.com/shaunsingh/nyoom.nvim/archive/ec3faaacb52207e99c54a66e04f5425adb772faa.tar.gz";
        sha256 = "0r3xwrjw07f8n35fb3s9w4kkavsciqwsw408bfi7vdfyax5fxc5x";
      };
      recursive = true;
    };

    env.PATH = [ "$HOME/.config/nvim/bin" ];
    environment.shellAliases = {
      vi = "nvim";
      vim = "nvim";
      v = "nvim";
    };
  };
}
