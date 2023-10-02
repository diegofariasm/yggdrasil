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

    # A util i am making myself.
    # Not nearly ready for use, but might be in a few years.
    maiden.url = "github:fushiii/maiden";
    maiden.inputs.nixpkgs.follows = "nixpkgs";

    # Managing home configurations.
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # We're using these libraries for other functions.
    flake-utils.url = "github:numtide/flake-utils";

    # Generate your NixOS systems to various formats!
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Managing your secrets.
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # The rice machine.
    # I have been using it for a while, nothing beats it.
    hyprland.url = "github:hyprwm/Hyprland";

    # Style your entire computer with nix.
    # This makes me want to never leave nix or nixos again.
    stylix.url = "github:danth/stylix";

    # List of curated themes to use with stylix.
    # Some are missing, but anyway.
    base16-schemes.flake = false;
    base16-schemes.url = "github:base16-project/base16-schemes";

  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      inherit (lib.my)
        mapModulesRec' mkHost mkHome mkImage listImagesWithSystems;
      # A set of images with their metadata that is usually built for usual
      # purposes. The format used here is whatever formats nixos-generators
      # support.
      images = listImagesWithSystems (lib.importTOML ./images.toml);

      # A set of users with their metadata to be deployed with home-manager.
      users = listImagesWithSystems (lib.importTOML ./users.toml);

      overlays = with inputs; [

        self.overlays.default

        maiden.overlays.default
      ] ++ (lib.attrValues self.overlays);
      defaultSystem = "x86_64-linux";

      systems = [
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      # Extend lib with my personal custom library,
      # as well as home-manager's library.
      lib = nixpkgs.lib.extend
        (self: super: {
          my = import ./lib {
            inherit inputs;
            lib = self;
          };
        }) // home-manager.lib;

      extraArgs = {
        inherit inputs;
        inherit lib;
      };

      # The shared configuration for the entire list of hosts for this cluster.
      # Take note to only set as minimal configuration as possible since we're
      # also using this with the stable version of nixpkgs.
      hostSharedConfig = { config, lib, pkgs, ... }: {
        # Only use imports as minimally as possible with the absolute
        # requirements of a host. On second thought, only on flakes with
        # optional NixOS modules.
        imports = with inputs; [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
        ];


        environment.systemPackages = with pkgs; [
          age
          nil
          git
          sops
          maiden
          nixpkgs-fmt
        ];


        home-manager.useGlobalPkgs = lib.mkDefault true;
        home-manager.useUserPackages = lib.mkDefault true;

        # Make all of the flake inputs
        # available to the home-manager modules.
        # Note: can not use extraArgs here because
        # the 'inherit lib there will collide with hm.
        # home-manager.extraSpecialArgs = extraArgs;

        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.sharedModules =
          (mapModulesRec' (toString ./modules/home-manager) import)
          ++ [ userSharedConfig ];

        programs = {
          gnupg.agent = lib.mkDefault {
            enable = true;
            enableSSHSupport = true;
          };
        };
        services.openssh.enable = lib.mkDefault true;

        system = {
          configurationRevision = lib.mkIf (self ? rev) self.rev;
          stateVersion = "23.11";
        };

        boot = {
          loader = {
            systemd-boot = {
              enable = lib.mkDefault true;
              configurationLimit = 10;
            };
            efi.canTouchEfiVariables = lib.mkDefault true;
          };
        };

      };

      # The default config for our home-manager configurations. This is also to
      # be used for sharing modules among home-manager users from NixOS
      # configurations with `nixpkgs.useGlobalPkgs` set to `true` so avoid
      # setting nixpkgs-related options here.
      userSharedConfig = { pkgs, config, osConfig, lib, ... }: {
        # TODO: find how to import some of the modules
        # in the place where they are needed.
        imports = with inputs; [
          stylix.homeManagerModules.stylix
          sops-nix.homeManagerModules.sops
        ];

        # Enable home-manager.
        # This also makes it able to manage itself.
        programs.home-manager.enable = true;

        # Necessary for home-manager to work with flakes, otherwise it will
        # look for a nixpkgs channel.
        home.stateVersion = osConfig.system.stateVersion or "23.11";
      };

      nixSettingsSharedConfig = { config, lib, pkgs, ... }: {
        # I want to capture the usual flakes to its exact version so we're
        # making them available to our system. This will also prevent the
        # annoying downloads since it always get the latest revision.
        nix.registry = lib.mapAttrs'
          (name: flake:
            let name' = if (name == "self") then "config" else name;
            in lib.nameValuePair name' { inherit flake; })
          inputs;

        # Parallel downloads! PARALLEL DOWNLOADS! It's like Pacman 6.0 all over
        # again.
        nix.package = pkgs.nixUnstable;

        # Set the configurations for the package manager.
        nix.settings = {
          # Set several binary caches.
          substituters = [
            "https://hyprland.cachix.org"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];

          # Sane config for the package manager.
          # TODO: Remove this after nix-command and flakes has been considered
          # stable.
          experimental-features = [ "nix-command" "flakes" "repl-flake" ];
          auto-optimise-store = lib.mkDefault true;
        };

        # Stallman-senpai will be disappointed.
        nixpkgs.config.allowUnfree = true;

        # Extend nixpkgs with our overlays except for the NixOS-focused modules
        # here.
        nixpkgs.overlays = overlays;
      };

    in
    {
      # Some sensible default configurations.
      nixosConfigurations = lib.mapAttrs
        (filename: host:
          let
            path = ./hosts/${filename};
            extraModules = [
              ({ lib, ... }: {
                config = lib.mkMerge [
                  { networking.hostName = lib.mkForce host._name; }

                  (lib.mkIf (host ? domain) {
                    networking.domain = lib.mkForce host.domain;
                  })
                ];

              })
              hostSharedConfig
              nixSettingsSharedConfig
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
      nixosModules = lib.my.importModules (lib.my.filesToAttr ./modules/nixos);

      # User configuration should be done in here.
      # This runs once for every user, so i won't
      # run into the same problem as i am right,
      # that is: home-manager only install the config
      # for the last user.
      homeConfigurations = lib.mapAttrs
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
                  nixpkgs.config.allowUnfree = true;
                };

                home = {
                  username = name;
                  homeDirectory =
                    metadata.home-directory or "/home/${config.home.username}";

                  stateVersion = lib.mkDefault "23.11";
                };

                programs.home-manager.enable = true;

                targets.genericLinux.enable = true;
              })
              nixSettingsSharedConfig
              userSharedConfig
              path
            ];
          in
          mkHome {
            inherit pkgs system extraModules extraArgs;
            home-manager-channel =
              metadata.home-manager-channel or "home-manager";
          })
        users;

      # Extending home-manager with my custom modules, if anyone cares.
      homeModules =
        lib.my.importModules (lib.my.filesToAttr ./modules/home-manager);

      # In case somebody wants to use my stuff to be included in nixpkgs.
      overlays = import ./overlays // {
        default = final: prev: import ./pkgs { pkgs = prev; };
      };

      # My custom packages, available in here as well. Though, I mainly support
      # "x86_64-linux". I just want to try out supporting other systems.
      packages = forAllSystems (system:
        inputs.flake-utils.lib.flattenTree
          (import ./pkgs { pkgs = import nixpkgs { inherit system; }; }));

      # This contains images that are meant to be built and distributed
      # somewhere else including those NixOS configurations that are built as
      # an ISO.
      images = forAllSystems (system:
        let
          images' =
            lib.filterAttrs (host: metadata: system == metadata._system) images;
        in
        lib.mapAttrs'
          (host: metadata:
            let
              inherit system;
              name = metadata._name;
              format = metadata.format or "iso";
              nixpkgs-channel = metadata.nixpkgs-channel or "nixpkgs";
              pkgs =
                import inputs."${nixpkgs-channel}" { inherit system overlays; };
            in
            lib.nameValuePair name (mkImage {
              inherit format system pkgs extraArgs;
              extraModules = [
                ({ lib, ... }: {
                  config = lib.mkMerge [
                    {
                      networking.hostName = lib.mkForce metadata.hostname or name;
                    }
                    (lib.mkIf (metadata ? domain) {
                      networking.domain = lib.mkForce metadata.domain;
                    })
                  ];
                })
                hostSharedConfig
                ./hosts/${name}
              ];
            }))
          images');

      # No amount of formatters will make this codebase nicer but it sure does
      # feel like it does.
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.treefmt);

    };
}

