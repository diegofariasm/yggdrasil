{

  description = "You are not supposed to be here!";

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

    # A util i am making myself.
    # Not nearly ready for use, but might be in a few years.
    maiden.url = "github:fushiii/maiden";
    maiden.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-colors, home-manager, ... }:
    let
      # A set of images with their metadata that is usually built for usual
      # purposes. The format used here is whatever formats nixos-generators
      # support.
      images = listImagesWithSystems (lib'.importTOML ./images.toml);

      # A set of users with their metadata to be deployed with home-manager.
      users = listImagesWithSystems (lib'.importTOML ./users.toml);

      # A set of image-related utilities for the flake outputs.
      inherit (import ./lib/images.nix { inherit inputs; lib = lib'; }) mkHost mkHome mkImage listImagesWithSystems;

      overlays = with inputs; [
        maiden.overlays.default
      ] ++ (lib'.attrValues self.overlays);

      defaultSystem = "x86_64-linux";
      systems = [
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      extraArgs = {
        inherit inputs;
      };

      # We're considering this as the variant since we'll export the custom
      # library as `lib` in the output attribute.
      lib' = nixpkgs.lib.extend (final: prev:
        import ./lib { lib = prev; }
        // import ./lib/private.nix { lib = final; }
      );

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
        ] ++ (lib'.modulesToList (lib'.filesToAttr ./modules/nixos));

        environment.systemPackages = with pkgs; [
          nixpkgs-fmt
          rnix-lsp
          flavours
          maiden
          sops
          git
          age
        ];

        home-manager = {
          useGlobalPkgs = true;
          sharedModules = [
            userSharedConfig
          ];
          extraSpecialArgs = extraArgs;
        };

        system.configurationRevision = lib'.mkIf (self ? rev) self.rev;
        system.stateVersion = "23.05";
      };

      # The default config for our home-manager configurations. This is also to
      # be used for sharing modules among home-manager users from NixOS
      # configurations with `nixpkgs.useGlobalPkgs` set to `true` so avoid
      # setting nixpkgs-related options here.
      userSharedConfig = { pkgs, config, lib, osConfig, ... }: {
        imports = with inputs; [
          sops-nix.homeManagerModules.sops
        ] ++ (lib'.modulesToList (lib'.filesToAttr ./modules/home-manager));

        home.stateVersion = osConfig.system.stateVersion;

        # Enable home-manager.
        # This also makes it able to manage itself.
        programs.home-manager.enable = true;
      };

      # This will be shared among NixOS and home-manager configurations.
      nixSettingsSharedConfig = { config, lib, pkgs, ... }: {

        # I want to capture the usual flakes to its exact version so we're
        # making them available to our system. This will also prevent the
        # annoying downloads since it always get the latest revision.
        nix.registry =
          lib.mapAttrs'
            (name: flake:
              let
                name' = if (name == "self") then "config" else name;
              in
              lib.nameValuePair name' { inherit flake; })
            inputs;

        # Parallel downloads! PARALLEL DOWNLOADS! It's like Pacman 6.0 all over
        # again.
        nix.package = pkgs.nixUnstable;

        # Set the configurations for the package manager.
        nix.settings =
          let
            substituters = [
              "https://nix-community.cachix.org"
            ];
          in
          {
            # Set several binary caches.
            inherit substituters;

            trusted-substituters = substituters;
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];

            # All of the users with the wheel group are trusted.
            # Anyway, they have the permission to rebuild the system so it doens't matter.
            trusted-users = [ "root" "@wheel" ];

            # Sane config for the package manager.
            # TODO: Remove this after nix-command and flakes has been considered
            # stable.
            #
            # Since we're using flakes to make this possible, we need it. Plus, the
            # UX of Nix CLI is becoming closer to Guix's which is a nice bonus.
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
      # Exposes only my library with the custom functions to make it easier to
      # include in other flakes for whatever reason may be.
      lib = import ./lib { lib = nixpkgs.lib; };

      # A list of NixOS configurations from the `./hosts` folder. It also has
      # some sensible default configurations.
      nixosConfigurations =
        lib'.mapAttrs
          (filename: host:
            let
              path = ./hosts/${filename};
              extraModules = [
                ({ lib, ... }: {
                  config = lib.mkMerge [
                    { networking.hostName = lib.mkForce host._name; }

                    (lib.mkIf (host ? domain)
                      { networking.domain = lib.mkForce host.domain; })
                  ];
                })

                hostSharedConfig
                nixSettingsSharedConfig
                path
              ];
            in
            mkHost {
              inherit extraModules extraArgs;
              system = host._system;
              nixpkgs-channel = host.nixpkgs-channel or "nixpkgs";
            })
          (lib'.filterAttrs (_: host: (host.format or "iso") == "iso") images);

      # We're going to make our custom modules available for our flake. Whether
      # or not this is a good thing is debatable, I just want to test it.
      nixosModules = lib'.importModules (lib'.filesToAttr ./modules/nixos);

      # I can now install home-manager users in non-NixOS systems.
      # NICE!
      homeConfigurations =
        lib'.mapAttrs
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
                  # To be able to use the most of our config as possible, we want
                  # both to use the same overlays.
                  nixpkgs.overlays = overlays;

                  # Stallman-senpai will be disappointed. :/
                  nixpkgs.config.allowUnfree = true;


                  # Setting the homely options.
                  home.username = name;
                  home.homeDirectory = metadata.home-directory or "/home/${config.home.username}";

                  # home-manager configurations are expected to be deployed on
                  # non-NixOS systems so it is safe to set this.
                  programs.home-manager.enable = true;
                })
                userSharedConfig
                nixSettingsSharedConfig
                path
              ];
            in
            mkHome {
              inherit pkgs system extraModules extraArgs;
              home-manager-channel = metadata.home-manager-channel or "home-manager";
            })
          users;

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
            lib'.filterAttrs (host: metadata: system == metadata._system) images;
        in
        lib'.mapAttrs'
          (host: metadata:
            let
              inherit system;
              name = metadata._name;
              format = metadata.format or "iso";
              nixpkgs-channel = metadata.nixpkgs-channel or "nixpkgs";
              pkgs =
                import inputs."${nixpkgs-channel}" { inherit system overlays; };
            in
            lib'.nameValuePair name (mkImage {
              inherit format system pkgs extraArgs;
              extraModules = [
                ({ lib, ... }: {
                  config = lib'.mkMerge [
                    {
                      networking.hostName = lib'.mkForce metadata.hostname or name;
                    }
                    (lib'.mkIf (metadata ? domain) {
                      networking.domain = lib'.mkForce metadata.domain;
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

