{ config, pkgs, lib, ... }:


let cfg = config.modules.services.podman;
in
{
  options.modules.services.podman = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {

    virtualisation = {
      podman = {
        enable = true;
      };
      docker.enable = false;
    };

    environment.systemPackages = with pkgs; [ podman-compose ];
  };
}
