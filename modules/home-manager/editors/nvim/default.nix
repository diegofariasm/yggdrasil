{ config, lib, pkgs, ... }:

let
  cfg = config.modules.editors.nvim;
in
{
  options.modules.editors.nvim = {
    enable = lib.mkOption {
      description = ''
        Wheter to install the nvim package.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    # Install the nvim binary
    home.packages = with pkgs; [
      neovim
    ];
    # Aliases.
    # Why would i use vim if i have
    # neovim installed?
    programs.zsh.shellAliases = {
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
    };

  };
}
