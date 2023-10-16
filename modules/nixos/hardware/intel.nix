{ config
, pkgs
, lib
, ...
}:

let
  cfg = config.modules.hardware.intel;
in
{
  options.modules.hardware.intel = {
    enable = lib.mkOption {

      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        vaapiVdpau
      ];
    };

  };
}
