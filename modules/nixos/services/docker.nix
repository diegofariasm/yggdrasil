{ config, lib, ... }:


let cfg = config.modules.services.docker;
in
{
  options.modules.services.docker = {
      enable = lib.mkOption {
      type = lib.types.bool;
       default = false;
       example = true;
     };
  };

  config = lib.mkIf cfg.enable {

    virtualisation = {
      docker = {
        enable = true;
      };
      podman.enable = false;
    };
  };
}
