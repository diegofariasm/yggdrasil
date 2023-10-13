{ config
, lib
, pkgs
, ...
}:

 let
  cfg = config.modules.hardware.zram;
in
{
  options.modules.hardware.zram = {
      enable = lib.mkOption {
      
     type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
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
