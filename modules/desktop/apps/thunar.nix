{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.thunar;
in {
  options.modules.desktop.apps.thunar = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
        xfce.thunar
    ];
  services = {
    xserver.desktopManager.xfce.thunarPlugins = with pkgs; [ 
      xfce.thunar-volman 
      xfce.thunar-archive-plugin 
      ];
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };


  };
}
