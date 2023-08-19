{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors;
in
{
  options.modules.editors = {
    default = mkOpt types.str "vim";
  };

  config = mkIf (cfg.default != null) {
    home.sessionVariables = {
      # Pass the default editor to the user environment.
      # Useful in case you generally open things.
      # Doesn't everyone?
      EDITOR = cfg.default;
    };
  };
}
