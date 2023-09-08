 { config, lib, ... }:
 with lib;
 with lib.my;
 let cfg = config.modules.services.podman;
 in {
   options.modules.services.podman = { enable = mkBoolOpt false; };

   config = mkIf cfg.enable {
     virtualisation = {
       docker.enable = lib.mkForce false;
       podman = {
         enable = true;
         autoPrune.enable = true;
         dockerSocket.enable = true;
         dockerCompat.enable = true;
       };
     };
   };
 }
