{ config, pkgs, lib, ... }:

with lib;
{
  options = with types; {
    dotfiles = {
      dir = mkOpt path
        (removePrefix "/mnt"
          (findFirst pathExists (toString ../..) [
            "/mnt/etc/nixos"
            "/etc/nixos"
          ]));
      binDir = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = mkOpt path "${config.dotfiles.dir}/modules";
    };

    # Ah yes, an idiotic thing to do.
    # This will be a list of commands, generally used between
    # all of the hosts. This make will it so that you can change between packages without that much of a hassle.
    maiden = mkOption {
      default = { };
      type = types.attrsOf types.anything;
      description = ''
        Maiden configuration made by nix.

        This will generate a config for the maiden tool, which wraps common commands.
        No need to keep changing binary names in your config anymore.
      '';
    };


  };
  config = {
    # Put the generated config in place.
    # Note: this will probably be changed later.
    xdg = {
      configFile = {
        "maiden/generated.toml" = {
          source = (pkgs.formats.toml { }).generate "maiden-toml-config"
            # Filter out all of the null values.
            # Note: toml doesn't support them, so that is needed.
            (lib.filterAttrsRecursive (name: value: value != null) config.maiden);
        };
      };
    };


    home = {
      # So this can be used throghout the config.
      # Gives me some peace being able to acess my dotfiles thorugh the variables.
      sessionVariables = with config.dotfiles; {
        "DOTFILES_BIN" = binDir;
        "DOTFILES_CONFIG" = configDir;
        "DOTFILES_MODULES" = modulesDir;
      };

      # Add a few things to path.
      # These are used in all of the users.
      sessionPath = [
        "$DOTFILES_BIN"
        "$XDG_BIN_HOME"
        "$PATH"
      ];
    };

  };
}
