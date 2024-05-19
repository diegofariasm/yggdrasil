{
  inputs,
  lib,
  defaultNixConf,
  ...
}: {
  setups.home-manager = {
    configs = {
      baldur = {
        systems = ["x86_64-linux"];

        modules = [
          inputs.nur.hmModules.nur
          inputs.sops-nix.homeManagerModules.sops
        ];
        # overlays = [
        #   inputs.kak-rainbower.overlays.default
        #   inputs.nur.overlay
        # ];
        deploy = {
          autoRollback = true;
          magicRollback = true;
        };
      };
    };

    # Pretty much the baseline home-manager configuration for the whole
    # cluster.
    sharedModules = [
      # ...plus a bunch of third-party modules.
      inputs.nix-index-database.hmModules.nix-index

      # The default shared config for our home-manager configurations. This
      # is also to be used for sharing modules among home-manager users from
      # NixOS configurations with `nixpkgs.useGlobalPkgs` set to `true` so
      # avoid setting nixpkgs-related options here.
      ({lib, ...}: {
        home.stateVersion = lib.mkDefault "24.05";
      })
    ];

    # sharedOverlays = [
    #   inputs.kak-rainbower.overlays.default
    # ];

    standaloneConfigModules = [
      defaultNixConf
      ({lib, ...}: {
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
