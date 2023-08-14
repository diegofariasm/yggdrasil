# A set of functions intended for creating images. THis is meant to be imported
# for use in flake.nix and nowhere else.
{ inputs, lib, modules, ... }:
let
  inherit (modules) mapModules mapModulesRec mapModulesRec';

in
{

  # A wrapper around the NixOS configuration function.
  mkHost = { system, extraModules ? [ ], extraArgs ? { }, nixpkgs-channel ? "nixpkgs" }:
    (lib.makeOverridable inputs."${nixpkgs-channel}".lib.nixosSystem) {
      # The system of the NixOS system.
      inherit system;
      specialArgs = extraArgs;

      modules =
        extraModules
        ++ (mapModulesRec' (toString ../modules/nixos) import);

    };

  # A wrapper around the home-manager configuration function.
  mkHome = { pkgs, path, system, extraModules ? [ ], extraArgs ? { }, home-manager-channel ? "home-manager" }:
    inputs."${home-manager-channel}".lib.homeManagerConfiguration {
      inherit lib pkgs;
      extraSpecialArgs = extraArgs;
      modules =
        extraModules
        ++ (mapModulesRec' (toString ../modules/home-manager) import);

      # Import the user configuration
      imports = [
        path
      ];
    };

  # A wrapper around the nixos-generators `nixosGenerate` function.
  mkImage = { system, pkgs ? null, extraModules ? [ ], extraArgs ? { }, format ? "iso" }:
    inputs.nixos-generators.nixosGenerate {
      inherit pkgs system format lib;
      specialArgs = extraArgs;
      modules =
        extraModules
        ++ (mapModulesRec' (toString ../modules/nixos) import);
    };

  listImagesWithSystems = data:
    lib.foldlAttrs
      (acc: name: metadata:
        let
          name' = metadata.hostname or name;
        in
        if lib.length metadata.systems > 1 then
          acc // (lib.foldl
            (images: system: images // {
              "${name'}-${system}" = metadata // {
                _system = system;
                _name = name';
              };
            })
            { }
            metadata.systems)
        else
          acc // {
            "${name'}" = metadata // {
              _system = lib.head metadata.systems;
              _name = name';
            };
          })
      { }
      data;
}
