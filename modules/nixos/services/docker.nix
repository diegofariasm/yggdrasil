{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.services.docker;
in
{
  options.modules.services.docker = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    virtualisation = {
      docker = {
        enable = true;
      };
      podman.enable = false;
    };

    environment = {
      systemPackages = with pkgs; [
        docker-sync
      ];
    };

  };
}
