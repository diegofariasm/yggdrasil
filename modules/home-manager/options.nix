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

    home.persist = {
      directories = mkOption {
        type = with types;
          listOf (either str (submodule {
            options = {
              directory = mkOption {
                type = str;
                default = null;
                description = "The directory path to be linked.";
              };
              method = mkOption {
                type = types.enum ["bindfs" "symlink"];
                default = "bindfs";
                description = ''
                  The linking method that should be used for this
                  directory. bindfs is the default and works for most use
                  cases, however some programs may behave better with
                  symlinks.
                '';
              };
            };
          }));
        default = [];
      };

      files = mkOption {
        type = with types; listOf str;
        default = [];
      };
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
            (lib.filterAttrsRecursive (name: value: value != null) config.maiden);
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
