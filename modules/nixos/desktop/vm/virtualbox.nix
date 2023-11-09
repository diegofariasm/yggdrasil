{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop.vm.virtualbox;
in
{
  options.modules.desktop.vm.virtualbox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox = {
      host = {
        enable = true;
      };
    };
  };
}
