{ config
, lib
, pkgs
, ...
}:

 let
  cfg = config.modules.hardware.fs;
in
{
  options.modules.hardware.fs = {
      enable = lib.mkOption {
      
     type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # Note: this module should only aid in cross os
    # filesystem compatibility.
    environment.systemPackages = with pkgs; [
      exfat
      ntfs3g
    ];
  };
}
