{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop.vm.qemu;
in
{
  options.modules.desktop.vm.qemu = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qemu
    ];
  };
}
