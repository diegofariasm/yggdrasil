{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.term.wezterm;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.term.wezterm = {
    enable = lib.mkOption {
      description = ''
        Wheter to install wezterm.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
   programs = {
     wezterm = {
         enable = true;
     };
   };

    home =  {
       packages = with pkgs; [ 
          wezterm 
       ];
    };

  };
}
