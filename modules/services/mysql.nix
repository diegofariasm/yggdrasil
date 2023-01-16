{ options
, config
, pkgs
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.mysql;
in
{
  options.modules.services.mysql = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mysql80;
    };
  };
}
