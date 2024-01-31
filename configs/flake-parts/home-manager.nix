{ inputs
, lib
, defaultExtraArgs
, defaultNixConf
, ...
}:

{
  setups.home-manager = {
    configs = {
      enmeei = {
        systems = ["x86_64-linux"  "aarch64-linux" ];
        overlays = [
          inputs.nur.overlay
        ];
        modules = [
          inputs.impermanence.nixosModules.home-manager.impermanence
          inputs.nur.hmModules.nur
        ];
      };
    };

    # This is to be used by the NixOS `home-manager.sharedModules` anyways.
    sharedModules = [
      # ...plus a bunch of third-party modules.
      inputs.sops-nix.homeManagerModules.sops

      # The default shared config for our home-manager configurations. This
      # is also to be used for sharing modules among home-manager users from
      # NixOS configurations with `nixpkgs.useGlobalPkgs` set to `true` so
      # avoid setting nixpkgs-related options here.
      ({ pkgs, config, lib, ... }: {
        # Set some extra, yeah?
        _module.args = defaultExtraArgs;

        manual = lib.mkDefault {
          html.enable = true;
          json.enable = true;
          manpages.enable = true;
        };

        home.stateVersion = lib.mkDefault "24.05";

      })
    ] ++ lib.my.modulesToList (lib.my.filesToAttr ../../modules/home-manager);

    standaloneConfigModules = [
      defaultNixConf

      ({ config, lib, ... }: {
        # Don't create the user directories since they are assumed to
        # be already created by a pre-installed system (which should
        # already handle them).
        xdg.userDirs.createDirectories = lib.mkForce false;

        programs.home-manager.enable = lib.mkForce true;
        targets.genericLinux.enable = lib.mkDefault true;
      })
    ];
  };

  flake = {
    # Extending home-manager with my custom modules, if anyone cares.
    homeModules.default = lib.my.filesToAttr ../../modules/home-manager;
  };
}
