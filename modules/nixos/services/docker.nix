{ config
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.docker;
in
{
  options.modules.services.docker = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      # Only start when needed.
      # There is some overhead for the first usage,
      # but other than that everything else works as expected.
      enableOnBoot = false;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
