{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.services.polkit;
in {
  config = let
    enabledPolkitAgents = lib.my.countAttrs (_: module: lib.isAttrs module && builtins.hasAttr "enable" module && module.enable) cfg;
  in
    lib.mkIf (enabledPolkitAgents > 0) {
      assertions = [
        {
          assertion = enabledPolkitAgents <= 1;
          message = ''
            Only one polkit agent should be enabled at any given time.
          '';
        }
      ];

      security.polkit.enable = true;
    };
}
