{ config, options, lib, home-manager, ... }:

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
      themesDir = mkOpt path "${config.dotfiles.modulesDir}/themes";
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs
        (n: v:
          if isList v
          then concatMapStringsSep ":" (x: toString x) v
          else (toString v));
      default = { };
      description = "TODO";
    };
  };

  config = {
    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    # environment.extraInit =
    #   concatStringsSep "\n"
    #     (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
