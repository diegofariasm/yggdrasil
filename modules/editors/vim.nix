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
        url = "https://github.com/fushiii/nyoom.nvim/archive/3cf0e44a42e9f5f0e96b0f65ee6056cba02d37ec.tar.gz";
        sha256 = "05xn2mv7r7pv00gc8v6bm8y0dz959j2jrkncx5gdyqxvxfxx8zhv";
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
