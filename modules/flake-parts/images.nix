# A custom flake-parts module to configure my NixOS images generated with
# nixos-generators. For more details, see the "Declarative hosts management"
# section from the documentation.
{
  config,
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (flake-parts-lib) mkSubmoduleOptions mkPerSystemOption;
in {
  options = {
    flake = mkSubmoduleOptions {
      images = lib.mkOption {
        type = with lib.types; lazyAttrsOf (attrsOf package);
        default = {};
        description = ''
          An attribute set of per-system NixOS configurations built as an image
          output supported by
          [nixos-generators](https://github.com/nix-community/nixos-generators).
        '';
      };
    };

    perSystem = mkPerSystemOption {
      options = {
        images = lib.mkOption {
          type = with lib.types; attrsOf package;
          default = {};
          description = ''
            An attribute set of NixOS configurations built as an image output
            supported by
            [nixos-generators](https://github.com/nix-community/nixos-generators).
          '';
        };
      };
    };
  };

  config = {
    flake.images =
      lib.mapAttrs
      (_k: v: v.images)
      (
        lib.filterAttrs
        (_k: v: v.images != {})
        config.allSystems
      );

    perInput = system: flake:
      lib.optionalAttrs (flake ? images.${system}) {
        images = flake.images.${system};
      };
  };
}
