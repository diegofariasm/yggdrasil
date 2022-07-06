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
  cfg = config.modules.editors.vim;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
        sha256 = "1pdkfz0m6i8gmyhkgpfmsf61mlzh5yj861s21zp9gcdd65pf38bk";
      }))
    ];

    user.packages = with pkgs; [
      neovim

     # Formatter
      nodePackages.prettier
      alejandra

      tree-sitter
      fd

      lua
      luarocks
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
