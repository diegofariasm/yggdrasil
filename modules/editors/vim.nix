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
      ];

    home.configFile."nvim" = {
      source = "${configDir}/nvim";
      recursive = true;
    };

    environment.shellAliases = {
      vi = "nvim";
      vim = "nvim";
      v = "nvim";
    };
  };
}
