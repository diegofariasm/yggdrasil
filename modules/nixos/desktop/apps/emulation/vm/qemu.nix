{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.emulation.vm.qemu;
in {
  options.modules.desktop.apps.emulation.vm.qemu = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qemu
    ];
  };
}
