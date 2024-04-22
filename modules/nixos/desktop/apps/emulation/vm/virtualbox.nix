{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.emulation.vm.virtualbox;
in {
  options.modules.desktop.apps.emulation.vm.virtualbox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox = {
      host = {
        enable = true;
        #  enableExtensionPack = true;
      };
    };
  };
}
