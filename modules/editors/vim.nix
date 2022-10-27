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
        # Language servers
        rnix-lsp # Nix
        sumneko-lua-language-server # Lua
        nodePackages.bash-language-server # Bash
      ];

    home.configFile."nvim" = {
      source = pkgs.fetchgit {
        url = "https://github.com/shaunsingh/nyoom.nvim";
        rev = "4ce896218dca6624d507bba3d37609877276b168";
        sha256 = "TCgIiCeyu4yZEpjp/D+qLdBdLlU9qtlpCQpOKANsT+E=";
        leaveDotGit = true;
        fetchSubmodules = false;
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
