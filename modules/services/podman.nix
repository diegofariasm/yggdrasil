{ config
, options
, pkgs
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.podman;
in
{
  options.modules.services.podman = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      # Automatically clean volumes
      autoPrune.enable = true;
      # So apps that rely on docker can use podman instead;
      dockerSocket.enable = true;
    };
    user.packages = with pkgs; [
      podman-desktop
      podman-compose
    ];
  };
}
