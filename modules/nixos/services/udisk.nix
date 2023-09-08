{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.udisk;
in
{
  options.modules.services.udisk = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Note: this needs to be enable for the home-manager option.
    # If you take this out, you won't be able to use udisk properly.
    services.udisks2 = {
      enable = true;
    };
  };
}
