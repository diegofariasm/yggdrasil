{ config, lib, ... }:

with lib;
with lib.my;
{
  options = with types; {
    dotfiles = {
      dir = mkOpt path
        (removePrefix "/mnt"
          (findFirst pathExists (toString ../..) [
            "/mnt/etc/dotfiles"
            "/etc/dotfiles"
          ]));
      binDir = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = mkOpt path "${config.dotfiles.dir}/modules";
    };

  };
  config = {
    # So this can be used throghout the config.
    # Gives me some peace being able to acess my
    # dotfiles thorugh the variables.
    home.sessionVariables = with config.dotfiles; {
      "DOTFILES_BIN" = binDir;
      "DOTFILES_CONFIG" = configDir;
      "DOTFILES_MODULES" = modulesDir;
    };

    # Add a few things to path.
    # These are used in all of the users.
    home.sessionPath = [
      "$DOTFILES_BIN"
      "$XDG_BIN_HOME"
      "$PATH"
    ];

  };
}
