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
    lib' =
      pkgs.lib.extend
      (self: _super: {
        my = import ../../../lib {
          inherit inputs;
          lib = self;
        };
      });
  in
    inputs.${homeManagerBranch}.lib.homeManagerConfiguration {
      inherit pkgs;
      lib = lib';
      modules = extraModules;
    };

  deploySettingsType = {
    config,
    lib,
    username,
    ...
  }: {
    freeformType = with lib.types; attrsOf anything;
    imports = [./shared/deploy-node-type.nix];

    options = {
      profiles = lib.mkOption {
        type = with lib.types; functionTo (attrsOf anything);
        default = homeenv: {
          home = {
            sshUser = username;
            user = username;
            path = inputs.deploy.lib.${homeenv.system}.activate.home-manager homeenv.config;
          };
        };
        defaultText = lib.literalExpression ''
          homeenv: {
            home = {
              sshUser = "$USERNAME";
              user = "$USERNAME";
              path = <deploy-rs>.lib.''${homeenv.system}.activate.home-manager homeenv.config;
            };
          }
        '';
        description = ''
          A set of profiles for the resulting deploy node.

          Since each config can result in more than one home-manager
          environment, it has to be a function where the passed argument is an
          attribute set with the following values:

          * `name` is the attribute name from `configs`.
          * `config` is the home-manager configuration itself.
          * `system` is a string indicating the platform of the NixOS system.

          If unset, it will create a deploy-rs node profile called `home`
          similar to those from nixops.
        '';
      };
    };
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

      deploy = lib.mkOption {
        type = with lib.types;
          nullOr (submoduleWith {
            specialArgs = {
              username = name;
            };
            modules = [deploySettingsType];
          });
        default = null;
        description = ''
          deploy-rs settings to be passed onto the home-manager configuration
          node.
        '';
      };
    };

    config.modules = [
      ../../../configs/home-manager/${config.configName}
      (
        let
          setupConfig = config;
        in
          {lib, ...}: {
            nixpkgs.overlays = setupConfig.overlays ++ partsConfig.setups.home-manager.sharedOverlays;
            home.username = lib.mkForce name;
            home.homeDirectory = lib.mkForce setupConfig.homeDirectory;
          }
      )
    ];
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

    sharedOverlays = lib.mkOption {
      type = with lib.types; listOf (functionTo raw);
      default = [];
      description = ''
        A list of overlays to be shared by all of the declarative NixOS setups.
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
            (import ./shared/nix-conf.nix {inherit inputs;})
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
          baldur = {
            systems = [ "aarch64-linux" "x86_64-linux" ];
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
    # Import our own home-manager modules.
    setups.home-manager.sharedModules = homeManagerModules;

    flake = let
      # A quick data structure we can pass through multiple build pipelines.
      pureHomeManagerConfigs = let
        generatePureConfigs = _username: metadata:
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

      deploy.nodes = let
        validConfigs =
          lib.filterAttrs
          (name: _: cfg.configs.${name}.deploy != null)
          pureHomeManagerConfigs;

        generateDeployNode = name: system: config:
          lib.nameValuePair "home-manager-${name}-${system}" (
            let
              deployConfig = cfg.configs.${name}.deploy;
              deployConfig' = lib.attrsets.removeAttrs deployConfig ["profiles"];
            in
              deployConfig'
              // {
                profiles = cfg.configs.${name}.deploy.profiles {
                  inherit name config system;
                };
              }
          );
      in
        lib.concatMapAttrs
        (name: configs:
          lib.mapAttrs' (generateDeployNode name) configs)
        validConfigs;
    };
  };
}
