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
      ];

    home.configFile."nvim" = {
      source = builtins.fetchTarball {
        url = "https://github.com/fushiii/nyoom.nvim/archive/823b0971ebbee5cb9a65a75fa05373ef80aa6052.tar.gz";
        sha256 = "1hkqkpghpg6c8qx5zhpjp1zwd02zgx0wdw8k8n0n4wni6zy23qay";
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
