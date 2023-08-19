{ config
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers;
in
{
  options.modules.desktop.browsers = {
    default = mkOpt (with types; nullOr str) null;
  };

  config = mkIf (cfg.default != null) {
    home.sessionVariables = {
      # Default browser for the user.
      # Note: not yet enforced on the mime apps.
      BROWSER = cfg.default;
    };
  };
}
