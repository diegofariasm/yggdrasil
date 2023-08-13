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

    maiden = mkOpt' attrs { } "Alias to home-manager. Make it easier to use it everywhere, indepently of the user.";
    home = {
      configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
      packages = mkOpt' attrs { } "Packages to install for the user";
      file = mkOpt' attrs { } "Files to place directly in $HOME";
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
    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;
      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.fushi.home.file.*'
      # is much too long and harder to maintain, so I've made aliases in:
      #
      #   home.file        ->  home-manager.users.fushi.home.file
      #   home.configFile  ->  home-manager.users.fushi.home.xdg.configFile
      #   home.dataFile    ->  home-manager.users.fushi.home.xdg.dataFile
      #   maiden.programs    ->  home-manager.users.fushi.programs
      users."fushi" = mkAliasDefinitions options.maiden;
    };

    maiden = {
      home = {
        file = mkAliasDefinitions options.home.file;
        packages = mkAliasDefinitions options.home.packages;
        # Necessary for home-manager to work with flakes, otherwise it will
        # look for a nixpkgs channel.
        stateVersion = config.system.stateVersion;
      };
      xdg = {
        dataFile = mkAliasDefinitions options.home.dataFile;
        configFile = mkAliasDefinitions options.home.configFile;
      };
    };

    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit =
      concatStringsSep "\n"
        (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
