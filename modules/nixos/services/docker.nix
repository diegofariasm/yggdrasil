{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.service.docker;
in {
  options.modules.service.docker.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [yggdrasil-act];
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
