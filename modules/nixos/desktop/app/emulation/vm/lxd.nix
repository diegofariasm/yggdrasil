# Inspired by https://www.srid.ca/2012301.html
{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.app.emulation.vm.lxd;
in {
  options.modules.desktop.app.emulation.vm.lxd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.lxd.enable = true;
  };
}
