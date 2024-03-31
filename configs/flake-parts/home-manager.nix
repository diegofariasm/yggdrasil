{
  inputs,
  lib,
  defaultNixConf,
  ...
}: {
  setups.home-manager = {
    configs = {
      diegofariasm = {
        systems = ["x86_64-linux"];
        overlays = [
          # Get all of the NUR.
          inputs.nur.overlay
        ];
        modules = with inputs; [
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
      };
    };

    # This is to be used by the NixOS `home-manager.sharedModules` anyways.
    sharedModules =
      [
        inputs.nix-index-database.hmModules.nix-index
        # The default shared config for our home-manager configurations. This
        # is also to be used for sharing modules among home-manager users from
        # NixOS configurations with `nixpkgs.useGlobalPkgs` set to `true` so
        # avoid setting nixpkgs-related options here.
        ({lib, ...}: {
          home.stateVersion = lib.mkDefault "24.05";
        })
      ]
      ++ lib.my.modulesToList (lib.my.filesToAttr ../../modules/home-manager);
  };

  flake = {
    # Extending home-manager with my custom modules, if anyone cares.
    homeModules.default = lib.my.filesToAttr ../../modules/home-manager;
  };
}
