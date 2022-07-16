{ config
, options
, lib
, home-manager
, ...
}:
with lib;
with lib.my; {
  options = with types; {
    user = mkOpt attrs { };

    dotfiles = {
      dir =
        mkOpt path
          (removePrefix "/mnt"
            (findFirst pathExists (toString ../.) [
              "/mnt/etc/dotfiles"
              "/etc/dotfiles"
            ]));
      binDir = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = mkOpt path "${config.dotfiles.dir}/modules";
      themesDir = mkOpt path "${config.dotfiles.modulesDir}/themes";
    };
    houseKeeper = mkOpt' attrs { } "House Manager alias";

    home = {
      file = mkOpt' attrs { } "Files to place directly in $HOME";
      configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
      programs = mkOpt' attrs { } "Programs to install";
      packages = mkOpt' attrs { } "Packages to install";

    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply =
        mapAttrs
          (n: v:
            if isList v
            then concatMapStringsSep ":" (x: toString x) v
            else (toString v));
      default = { };
      description = "TODO";
    };
  };

  config = {
    user =
      let
        user = builtins.getEnv "USER";
        name =
          if elem user [ "" "root" ]
          then "fushi"
          else user;
      in
      {
        inherit name;
        description = "${name}'s account";
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        home = "/home/${name}";
        group = "users";
        uid = 1000;
      };

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.

    home-manager = {
      useUserPackages = true;

      # These are the aliases for homeManager

      users.${config.user.name} = mkAliasDefinitions options.houseKeeper;


      houseKeeper =
        {

          # houseKeeper -> home-manager.users.fushi
          #   home.file        ->  home-manager.users.fushi.home.file
          #   home.configFile  ->  home-manager.users.fushi.home.xdg.configFile
          #   home.dataFile    ->  home-manager.users.fushi.home.xdg.dataFile
          #   home.programs    ->  home-manager.users.fushi.programs
          #   home.packages     -> home-manager.users.fushi.home.packages

          programs = mkAliasDefinitions options.home.programs;
          home = {
            file = mkAliasDefinitions options.home.file;
            packages = mkAliasDefinitions options.home.packages;

            # Necessary for home-manager to work with flakes, otherwise it will
            # look for a nixpkgs channel.
            stateVersion = config.system.stateVersion;
          };
          xdg = {
            configFile = mkAliasDefinitions options.home.configFile;
            dataFile = mkAliasDefinitions options.home.dataFile;
          };
        };


      users.users.${config.user.name} = mkAliasDefinitions options.user;

      nix.settings =
        let
          users = [ "root" config.user.name ];
        in
        {
          trusted-users = users;
          allowed-users = users;
        };

      # must already begin with pre-existing PATH. Also, can't use binDir here,
      # because it contains a nix store path.
      env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

      environment.extraInit =
        concatStringsSep "\n"
          (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
    };
  }
