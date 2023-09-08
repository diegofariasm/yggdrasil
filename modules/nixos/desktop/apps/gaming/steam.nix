 { pkgs, config, inputs, lib, ... }:
 with lib;
 with lib.my;
 let cfg = config.modules.desktop.apps.gaming.steam;

 in {
   options.modules.desktop.apps.gaming.steam = { enable = mkBoolOpt false; };

   config = mkIf cfg.enable {

     programs.steam = {
       enable = true;
       remotePlay.openFirewall = true;
     };

     hardware.steam-hardware.enable = true;
     environment.systemPackages = with pkgs; [ steam-tui ];
   };
 }
