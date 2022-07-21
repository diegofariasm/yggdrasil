# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.
{ config
, options
, lib
, pkgs
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
    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
        sha256 = "0bvd65mgafkvwmd3nw3lymc2bza9q48cjvpvp80sp4151i3n9jq8";
      }))
    ];

    home.packages = with pkgs; [
      neovim
      rnix-lsp # Language server for nix
      fennel
      fnlfmt
      parinfer-rust
      gcc
      sumneko-lua-language-server
    ];

    home.configFile."nvim" = {
      source = "${configDir}/nvim";
      recursive = true;
    };

    environment.shellAliases = {
      vim = "nvim";
      v = "nvim";
    };
  };
}
