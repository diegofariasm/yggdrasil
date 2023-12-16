{ config
, lib
, ...
}:

let
  cfg = config.modules.services.docker;
in
{
  options.modules.services.docker.enable = lib.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    virtualisation.docker.rootless = {
      enable = true;
      # Set the socket variable to the rootless one.
      # Without this, it will try to reach the one that needs root.
      setSocketVariable = true;
      daemon.settings = {
        # My provider, for some reason,
        # doesn't really seem to provide ipv6 support.
        ipv6 = false;
      };
    };
  };
}
