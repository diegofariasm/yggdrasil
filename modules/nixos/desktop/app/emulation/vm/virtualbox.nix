{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.app.emulation.vm.virtualbox;
in {
  options.modules.desktop.app.emulation.vm.virtualbox = {
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
