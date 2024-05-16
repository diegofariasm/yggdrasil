{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.services.notifier;
in {
  config = let
    enabledPAgents = lib.my.countAttrs (_: module: lib.isAttrs module && builtins.hasAttr "enable" module && module.enable) cfg;
  in
    lib.mkIf (enabledPAgents > 0) {
      assertions = [
        {
          assertion = enabledPAgents <= 1;
          message = ''
            Only one notifier agent should be enabled at any given time.
          '';
        }
      ];
    };
}
