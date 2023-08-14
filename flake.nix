# Welcome to ground zero. Where the whole flake gets set up and all its modules
# are loaded.
{
  description = "You shall meet your doom here";

  inputs = {
    # I know NixOS can be stable but we're going cutting edge, baybee! While
    # `nixpkgs-unstable` branch could be faster delivering updates, it is
    # looser when it comes to stability for the entirety of this configuration.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Here are the nixpkgs variants used for creating the system configuration
    # in `mkHost`.
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # Generate your NixOS systems to various formats!
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # We're using these libraries for other functions.
    flake-utils.url = "github:numtide/flake-utils";

    # Managing home configurations.
    home-manager.url = "github:nix-community/home-manager";

    # This is what AUR strives to be.
    nur.url = "github:nix-community/NUR";

    # Extras
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , nixpkgs-unstable
    , ...
    }:
    let
      inherit (lib.my) mapModules mapModulesRec mapModulesRec' mkHost mkHome mkImage listImagesWithSystems importTOML;
      # A set of images with their metadata that is usually built for usual
      # purposes. The format used here is whatever formats nixos-generators
      # support.
      images = listImagesWithSystems (lib.importTOML ./images.toml);

      # A set of users with their metadata to be deployed with home-manager.
      users = listImagesWithSystems (lib.importTOML ./users.toml);

      # NOTE: i am not sure wheter is a version mismatch between the libraries
      # nixpkgs version. So, this is kinda of a hack to be able to use my things
      # throughout the system.
      lib =
        nixpkgs.lib.extend
          (self: super: {
            my = import ./lib {
              inherit inputs;
              lib = self;
            };
          });

      extraArgs = {
        inherit inputs;
        inherit lib;
      };

      # The shared configuration for the entire list of hosts for this cluster.
      # Take note to only set as minimal configuration as possible since we're
      # also using this with the stable version of nixpkgs.
      sharedConfig = { config, lib, pkgs, ... }: {
        # Default configuration for all of my machines:
        # "default.nix".
        imports = [
          ./.
        ];

      };

      # The order here is important(?).
      overlays = [
        # Put my custom packages to be available.
        self.overlays.default

        # Access to NUR.
        inputs.nur.overlay
      ];

      defaultSystem = "x86_64-linux";
      # Just add systems here and it should add systems to the outputs.
      systems = with inputs.flake-utils.lib.system; [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      # Some sensible default configurations.
      nixosConfigurations =
        lib.mapAttrs
          (filename: host:
            let
              path = ./hosts/${filename};
              extraModules = [
                ({ lib, ... }: {
                  config = lib.mkMerge [
                    { nixpkgs.config.allowUnfree = true; }
                    { networking.hostName = lib.mkForce host._name; }
                  ];
                })
                sharedConfig
                path
              ];
            in
            mkHost {
              nixpkgs-channel = host.nixpkgs-channel or "nixpkgs";
              inherit extraModules extraArgs;
              system = host._system;
            })
          (lib.filterAttrs (_: host: (host.format or "iso") == "iso") images);


      # We're going to make our custom modules available for our flake. Whether
      # or not this is a good thing is debatable, I just want to test it.
      nixosModules =
        lib.importModules (lib.filesToAttr ./modules/nixos);
      # User configuration should be done in here.
      # This runs once for every user, so i won't
      # run into the same problem as i am right,
      # that is: home-manager only install the config
      # for the last user.
      homeConfigurations =
        lib.mapAttrs
          (filename: metadata:
            let
              name = metadata._name;
              system = metadata._system;
              pkgs = import inputs."${metadata.nixpkgs-channel or "nixpkgs"}" {
                inherit system overlays;
              };
              path = ./users/${name};
              extraModules = [
                ({ pkgs, config, ... }: {
                  nixpkgs = {
                    # To be able to use the most of our config as possible, we want
                    # both to use the same overlays.
                    overlays = overlays;

                    # Stallman-senpai will be disappointed. :/
                    config.allowUnfree = true;
                  };

                  programs.home-manager.enable = true;
                })
                sharedConfig
              ];
            in
            mkHome {
              inherit pkgs system extraModules extraArgs path;
              home-manager-channel = metadata.home-manager-channel or "home-manager";
            })
          users;

      # Extending home-manager with my custom modules, if anyone cares.
      homeModules =
        lib.importModules (lib.filesToAttr ./modules/home-manager);

      # In case somebody wants to use my stuff to be included in nixpkgs.
      overlays.default = final: prev: import ./pkgs { pkgs = prev; };

      # My custom packages, available in here as well. Though, I mainly support
      # "x86_64-linux". I just want to try out supporting other systems.
      packages = forAllSystems (system:
        inputs.flake-utils.lib.flattenTree (import ./pkgs {
          pkgs = import nixpkgs { inherit system; };
        }));

      # This contains images that are meant to be built and distributed
      # somewhere else including those NixOS configurations that are built as
      # an ISO.
      images =
        forAllSystems (system:
          let
            images' = lib.filterAttrs (host: metadata: system == metadata._system) images;
          in
          lib.mapAttrs'
            (host: metadata:
              let
                inherit system;
                name = metadata._name;
                format = metadata.format or "iso";
                nixpkgs-channel = metadata.nixpkgs-channel or "nixpkgs";
                pkgs = import inputs."${nixpkgs-channel}" { inherit system overlays; };
              in
              lib.nameValuePair name (mkImage {
                inherit format system pkgs extraArgs;
                extraModules = [
                  ({ lib, ... }: {
                    config = lib.mkMerge [
                      { nixpkgs.config.allowUnfree = true; }
                      { networking.hostName = lib.mkForce metadata.hostname or name; }
                    ];
                  })
                  sharedConfig
                  ./hosts/${name}
                ];
              }))
            images');
    };
}
