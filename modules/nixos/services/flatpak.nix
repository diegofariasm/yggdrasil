{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.flatpak;
in {
  options.modules.services.flatpak.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
