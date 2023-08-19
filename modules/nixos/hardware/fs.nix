{ config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.fs;
in
{
  options.modules.hardware.fs = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Note: this module should only aid in cross os
    # filesystem compatibility.
    environment.systemPackages = with pkgs; [
      exfat
      ntfs3g
    ];
  };
}
