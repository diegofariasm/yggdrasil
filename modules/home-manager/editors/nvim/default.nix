{ config, options, lib, pkgs, ... }:

let
  cfg = config.modules.editors.nvim;
in
{
  options.modules.editors.nvim = {
    enable = lib.mkEnableOption "Wheter to enable the config for neovim.";
  };

  config = lib.mkIf cfg.enable {
    home.mutableFile = {
      ".config/nvim" = {
        url = "https://github.com/fushiii/nyoom.nvim";
        type = "git";
      };
    };
  };
}
