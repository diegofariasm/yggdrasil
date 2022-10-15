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
        rnix-lsp # Language server for nix
        fennel
        fnlfmt
        ripgrep
        sumneko-lua-language-server
        luarocks
        # Needed for install
        gcc
        zig
      ];

    #    home.configFile."nvim" = {
    #      source = pkgs.fetchFromGitHub {
    #        owner = "yrashk";
    #        repo = "calendar";
    #        sha256 = "1xfax18y4ddafzmwqp8qfs6k34nh163bwjxb7llvls5hxr79vr9s";
    #        rev = "1ed19a3";
    #      };
    #      recursive = true;
    #    };
    
    home.configFile."nvim" = {
      source = pkgs.fetchzip {
        url = "https://github.com/shaunsingh/nyoom.nvim";
        sha256 = "1xfax18y4ddafzmwqp8qfs6k34nh163bwjxb7llvls5hxr79vr9s";
      };
      recursive = true;
    };
    environment.shellAliases = {
      vi = "nvim";
      vim = "nvim";
      v = "nvim";
    };
  };
}
