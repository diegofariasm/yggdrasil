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
        sha256 = "18zrsgkc68rkxkap261klvkwx7lazzmkkgmm0w00z0cdgsw93i4v";
      }))
    ];

    user.packages = with pkgs; [
      neovim
      editorconfig-core-c
      tree-sitter
      fd
      luarocks
      lua
      sumneko-lua-language-server # Lua language server, needed for deugging the config files
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
