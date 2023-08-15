{ config, options, lib, pkgs, ... }:

let
  cfg = config.modules.editors.nvim;


in
{
  options.modules.editors.nvim = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable my nyoom.nvim config.

         Take note you have to install nvim to be able to use this.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hello
    ];
  };
}
