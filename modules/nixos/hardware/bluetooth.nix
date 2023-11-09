{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
    };
  };
}
