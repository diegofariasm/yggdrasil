{ config
, options
, pkgs
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.docker;
in
{
  options.modules.services.docker = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    virtualisation.docker = {
      enable = true;
      # Don't start when not needed
      enableOnBoot = false;
      # No root
      # rootless = {
      #   enable = true;
      #   # Point DOCKER_HOST to rootless Docker instance for normal users by default.
      #   setSocketVariable = true;
      # };
      # Automatically clean volumes
      autoPrune.enable = true;
    };

    # Run docker without sudo
    user.extraGroups = [
      "docker"
    ];

  };
}
