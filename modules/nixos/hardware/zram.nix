{ config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.zram;
in
{
  options.modules.hardware.zram = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Note: this should make the system a little bit snappier
    # It also helps as it doesn't abuse your ssd as much with the swap writes.
    zramSwap = {
      enable = true;
      # Note: you probably can't use this algorithm
      # with the stable kernel.
      algorithm = "zstd";
      # This should be fine with 8G of ram.
      # But you can also make it lower.
      memoryPercent = 50;
    };

  };
}
