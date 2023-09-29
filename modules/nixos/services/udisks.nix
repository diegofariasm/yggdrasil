{ config
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.udisks;
in
{
  options.modules.services.udisks = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Enable udisks to be able
    # to get the battery information in other places.
    services = {
      udisks2 = {
        enable = true;
      };
    };
    # envrionment = {
    #   systemPackages = with pkgs; [
    #     udisks2
    #   ];
    # };
  };
}
