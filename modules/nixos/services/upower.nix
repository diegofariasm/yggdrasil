{ config
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.upower;
in
{
  options.modules.services.upower = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Enable upower to be able
    # to get the battery information in other places.
    services.upower = {
      enable = true;
      # Set the margins for the percentage.
      percentageLow = 15;
      percentageCritical = 10;
    };
  };
}