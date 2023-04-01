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
      # Alias podman to docker
      dockerCompat = true;
      # So docker tools can use the podman socket
      dockerSocket.enable = true;
    };
  };
}
