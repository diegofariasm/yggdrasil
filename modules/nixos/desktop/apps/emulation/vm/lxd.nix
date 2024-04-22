# Inspired by https://www.srid.ca/2012301.html
{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.emulation.vm.lxd;
in {
  options.modules.desktop.apps.emulation.vm.lxd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.lxd.enable = true;
  };
}
