{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.service.podman;
in {
  options.modules.service.podman.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [yggdrasil-act podman-compose];

    virtualisation.podman = {
      enable = true;

      dockerSocket.enable = true;
      dockerCompat = true;

      autoPrune = {
        enable = true;
        flags = [
          "--all"
        ];
      };
    };
  };
}
