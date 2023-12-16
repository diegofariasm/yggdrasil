{ config, pkgs, lib, ... }:

let
  cfg = config.modules.boot.loader.systemd;
in
{
  options.modules.boot.loader.systemd.enable = lib.mkOpt lib.types.bool false;
  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
  };

}
