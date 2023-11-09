{ config, pkgs, lib, ... }:

let
  cfg = config.modules.boot.loader.systemd;
in
{
  options.modules.boot.loader.systemd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
      };
      grub.enable = lib.mkForce false;
    };
  };

}
