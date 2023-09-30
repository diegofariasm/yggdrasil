 { options, config, inputs, lib, pkgs, ... }:

 with lib;
 with lib.my;
 let cfg = config.modules.theme;
 in {
   config = mkIf (cfg.active == "tokyo") {

     modules.theme.wallpaper = mkDefault ./config/wallpaper.jpg;

     # Set the theme for the applications.
     stylix.base16Scheme = ./config/tokyo.yaml;

   };

 }
