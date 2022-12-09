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
    nixpkgs.overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];

    home.programs.neovim = {

      enable = true;
      package = pkgs.neovim-unwrapped;

      # Setting the aliases
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs; [
        rnix-lsp
        nodePackages.bash-language-server
        sumneko-lua-language-server
        vimPlugins.nvim-treesitter
      ];


      plugins = with pkgs.vimPlugins; [
        hydra-nvim
        gitsigns-nvim
      ];


    };
    home.packages = with pkgs; [
      neovide
    ];
    #home.configFile."nvim" = {
    # source = builtins.fetchTarball {
    #    url = "https://github.com/fushiii/nyoom.nvim/archive/4dd5fea32a6394098d2e479624b8118871b7cf91.tar.gz";
    #    sha256 = "092n8cwh7zwyrpmqridpa3xc3aan9bid18wqpz3bhyii34gvc4dg";
    #  };
    #  recursive = true;
    #};

    # adds the nyom bin to the shell path
    env.PATH = [ "$HOME/.config/nvim/bin" ];

  };
}
