{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = with types; {
    # Ah yes, an idiotic thing to do.
    # This will be a list of commands, generally used between
    # all of the hosts. This make will it so that you can change between packages without that much of a hassle.
    maiden = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      description = ''
        Maiden configuration made by nix.

        This will generate a config for the maiden tool, which wraps common commands.
        No need to keep changing binary names in your config anymore.
      '';
    };
  };

  config = {
    xdg = {
      configFile = {
        "maiden/generated.toml" = {
          source =
            (pkgs.formats.toml {}).generate "maiden-toml-config"
            # Filter out all of the null values.
            # Note: toml doesn't support them, so that is needed.
            (lib.filterAttrsRecursive (_name: value: value != null) config.maiden);
        };
      };
    };

    home = {
      # Add a few things to path.
      # These are used in all of the users.
      sessionPath = [
        "$XDG_BIN_HOME"
        "$PATH"
      ];
    };
  };
}
