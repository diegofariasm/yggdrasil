{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.services.docker;
in {
  options.modules.services.docker.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [yggdrasil-act];
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon = {
          settings = {
            ipv6 = false;
          };
        };
      };
    };
  };
}
