{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.services.podman;
in {
  options.modules.services.podman = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = lib.mkForce false;
      # A docker replacemnt.
      # Should be a dropin thing.
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
      };
    };

    environment = {
      # Some useful things.
      systemPackages = with pkgs; [
        podman-compose
      ];
    };
  };
}
