{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.ollama;
in {
  options.modules.services.ollama.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    services.ollama.enable = true;
  };
}
