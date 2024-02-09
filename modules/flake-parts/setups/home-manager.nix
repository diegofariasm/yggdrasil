# This is the declarative user management converted into a flake-parts module.
{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.setups.home-manager;
  homeManagerModules = lib.my.modulesToList (lib.my.filesToAttr ../../home-manager);
  partsConfig = config;

  # A thin wrapper around the home-manager configuration function.
  mkHome = {
    system,
    nixpkgsBranch ? "nixpkgs",
    homeManagerBranch ? "home-manager",
    extraModules ? [],
  }: let
    pkgs = inputs.${nixpkgsBranch}.legacyPackages.${system};
  in
    inputs.${homeManagerBranch}.lib.homeManagerConfiguration {
      inherit pkgs;
      lib =
        inputs.nixpkgs.lib.extend
        (self: super: {
          my = import ../../../lib {
            inherit inputs;
            lib = self;
          };
        });
      modules = extraModules;
    };

  configType = {
    config,
    name,
    lib,
    ...
  }: {
    options = {
      overlays = lib.mkOption {
        type = with lib.types; listOf (functionTo raw);
        default = [];
        example = lib.literalExpression ''
          [
            inputs.neovim-nightly-overlay.overlays.default
            inputs.emacs-overlay.overlays.default
          ]
        '';
        description = ''
          A list of overlays to be applied for that host.
        '';
      };

      nixpkgsBranch = lib.mkOption {
        type = lib.types.str;
        default = "nixpkgs";
        example = "nixos-unstable-small";
        description = ''
          The nixpkgs branch to be used for evaluating the NixOS configuration.
          By default, it will use the `nixpkgs` flake input.

          ::: {.note}
          This is based from your flake inputs and not somewhere else. If you
          want to have support for multiple nixpkgs branch, simply add them as
          a flake input.
          :::
        '';
      };

      homeManagerBranch = lib.mkOption {
        type = lib.types.str;
        default = "home-manager";
        example = "home-manager-stable";
        description = ''
          The home-manager branch to be used for the NixOS module. By default,
          it will use the `home-manager` flake input.
        '';
      };

      homeDirectory = lib.mkOption {
        type = lib.types.path;
        default = "/home/${name}";
        example = "/var/home/public-user";
        description = ''
          The home directory of the home-manager user.
        '';
      };
    };

    config = {
      modules = [
        ../../../configs/home-manager/${name}
        (
          let
            setupConfig = config;
          in
            {
              config,
              lib,
              ...
            }: {
              nixpkgs.overlays = setupConfig.overlays;
              home = {
                username = lib.mkForce name;
                homeDirectory = lib.mkForce setupConfig.homeDirectory;
              };
            }
        )
      ];
    };
  };
in {
  options.setups.home-manager = {
    sharedModules = lib.mkOption {
      type = with lib.types; listOf raw;
      default = [];
      description = ''
        A list of modules to be shared by all of the declarative home-manager
        setups.

        ::: {.note}
        Note this will be shared into NixOS as well through the home-manager
        NixOS module.
        :::
      '';
    };

    standaloneConfigModules = lib.mkOption {
      type = with lib.types; listOf raw;
      default = [];
      internal = true;
      description = ''
        A list of modules to be added alongside the shared home-manager modules
        in the standalone home-manager configurations.

        This is useful for modules that are only suitable for standalone
        home-manager configurations compared to home-manager configurations
        used as a NixOS module.
      '';
    };

    configs = lib.mkOption {
      type = with lib.types;
        attrsOf (submoduleWith {
          specialArgs = {inherit (config) systems;};
          modules = [
            ./shared/config-options.nix
            configType
          ];
        });
      default = {};
      description = ''
        An attribute set of metadata for the declarative home-manager setups.
      '';
      example = lib.literalExpression ''
        {
          enmeei = {
            systems = [  "x86_64-linux" ];
            modules = [
              inputs.nur.hmModules.nur
            ];
            overlays = [
              inputs.neovim-nightly-overlay.overlays.default
              inputs.emacs-overlay.overlays.default
              inputs.helix-editor.overlays.default
              inputs.nur.overlay
            ];
          };

          plover.systems = [ "x86_64-linux" ];
        }
      '';
    };
  };

  config = lib.mkIf (cfg.configs != {}) {
    flake = let
      # A quick data structure we can pass through multiple build pipelines.
      pureHomeManagerConfigs = let
        generatePureConfigs = username: metadata:
          lib.listToAttrs
          (builtins.map
            (
              system:
                lib.nameValuePair system (mkHome {
                  inherit (metadata) nixpkgsBranch homeManagerBranch;
                  inherit system;
                  extraModules =
                    cfg.sharedModules
                    ++ cfg.standaloneConfigModules
                    ++ metadata.modules;
                })
            )
            metadata.systems);
      in
        lib.mapAttrs generatePureConfigs cfg.configs;
    in {
      homeConfigurations = let
        renameSystems = name: system: config:
          lib.nameValuePair "${name}-${system}" config;
      in
        lib.concatMapAttrs
        (name: configs:
          lib.mapAttrs' (renameSystems name) configs)
        pureHomeManagerConfigs;
    };
  };
}
