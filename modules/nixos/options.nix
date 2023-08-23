{ config, options, lib, home-manager, ... }:

with lib;
with lib.my;
{
  options = with types; {
    # Dotfiles dir. Used for the overlays.
    # Note: find way of sharing this with home-manager
    dotfiles = {
      dir = mkOpt path
        (removePrefix "/mnt"
          (findFirst pathExists (toString ../..) [
            "/mnt/etc/dotfiles"
            "/etc/dotfiles"
          ]));
      binDir     = mkOpt path "${config.dotfiles.dir}/bin";
      configDir  = mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = mkOpt path "${config.dotfiles.dir}/modules";
      themesDir  = mkOpt path "${config.dotfiles.modulesDir}/themes";
    };
  };

}
