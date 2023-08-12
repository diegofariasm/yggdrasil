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

    home-manager.url = "github:rycee/home-manager/master";
    # This is what AUR strives to be.
    nur.url = "github:nix-community/NUR";

    # Extras
    nixos-hardware.url = "github:nixos/nixos-hardware";
    hyprland.url = "github:hyprwm/Hyprland";

  };

  outputs =
    inputs @ { self
    , nixpkgs
    , nixpkgs-unstable
    , ...
    }:
    let
      inherit (lib.my) mapModules mapModulesRec mapModulesRec' mkHost mkHome listImagesWithSystems importTOML;
      # A set of images with their metadata that is usually built for usual
      # purposes. The format used here is whatever formats nixos-generators
      # support.
      images = listImagesWithSystems (lib.importTOML ./images.toml);

      # A set of users with their metadata to be deployed with home-manager.
      users = listImagesWithSystems (lib.importTOML ./users.toml);

      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true; # forgive me Stallman senpai
          overlays = extraOverlays ++ (lib.attrValues self.overlays);
        };

      pkgs = mkPkgs nixpkgs [ self.overlay ];

      lib =
        nixpkgs.lib.extend
          (self: super: {
            my = import ./lib {
              inherit pkgs inputs;
              lib = self;
            };
          });

      extraArgs = {
        inherit inputs;
        inherit lib;
      };

      # We're considering this as the variant since we'll export the custom
      # library as `lib` in the output attribute.
      lib' = nixpkgs.lib.extend (final: prev:
        import ./lib/utils.nix { lib = prev; }
        // import ./lib/private.nix { lib = final; });

      # All of my personal modules.
      # Note: they are pretty unstable, as i will
      # be making changes as i learn more nix.
      nixosModules = (mapModulesRec' (toString ./modules/nixos) import);
      homeModules = (mapModulesRec' (toString ./modules/home-manager) import);

      # The shared configuration for the entire list of hosts for this cluster.
      # Take note to only set as minimal configuration as possible since we're
      # also using this with the stable version of nixpkgs.
      hostSharedConfig = { config, lib, pkgs, ... }: {
        # Some defaults for evaluating modules.
        _module.check = true;
        # Only use imports as minimally as possible with the absolute
        # 1requirements of a host. On second thought, only on flakes with
        # optional NixOS modules.

        imports = [
          inputs.home-manager.nixosModules.home-manager
        ] ++ nixosModules;

        # Home manager modules
        maiden.imports = homeModules;

        # BOOOOOOOOOOOOO! Somebody give me a tomato!
        services.xserver.excludePackages = with pkgs; [ xterm ];

        # Set several paths for the traditional channels.
        nix.nixPath =
          lib.mapAttrsToList
            (name: source:
              let
                name' = if (name == "self") then "config" else name;
              in
              "${name'}=${source}")
            inputs
          ++ [
            "/nix/var/nix/profiles/per-user/root/channels"
          ];

        boot = {
          kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
          loader = {
            efi.canTouchEfiVariables = lib.mkDefault true;
            systemd-boot = {
              enable = lib.mkDefault true;
              configurationLimit = 5;
            };

          };
        };


      };


      # The default config for our home-manager configurations. This is also to
      # be used for sharing modules among home-manager users from NixOS
      # configurations with `nixpkgs.useGlobalPkgs` set to `true` so avoid
      # setting nixpkgs-related options here.
      userSharedConfig = { pkgs, config, lib, ... }: {

        programs.home-manager.enable = true;

        home.stateVersion = lib.lib.mkDefault "23.11";
      };

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
        nix.settings = {
          # Set several binary caches.
          substituters = [
            "https://nix-community.cachix.org"
            "https://foo-dogsquared.cachix.org"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "foo-dogsquared.cachix.org-1:/2fmqn/gLGvCs5EDeQmqwtus02TUmGy0ZlAEXqRE70E="
          ];

          # Sane config for the package manager.
          # TODO: Remove this after nix-command and flakes has been considered
          # stable.
          #
          # Since we're using flakes to make this possible, we need it. Plus, the
          # UX of Nix CLI is becoming closer to Guix's which is a nice bonus.
          experimental-features = [ "nix-command" "flakes" "repl-flake" ];
          auto-optimise-store = lib.lib.mkDefault true;
        };

        # Stallman-senpai will be disappointed.
        nixpkgs.config.allowUnfree = true;

        # Extend nixpkgs with our overlays except for the NixOS-focused modules
        # here.
        # nixpkgs.overlays = overlays;
      };

      # The order here is important(?).
      overlays = [
        # Put my custom packages to be available.
        self.overlays.default

        # Access to NUR.
        inputs.nur.overlay
      ];
    in
    {
      lib = lib.my;

      overlay = final: prev: {
        my = self.packages."${system}";
      };

      overlays =
        mapModules ./overlays import;

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
                  ];
                })
                nixSettingsSharedConfig
                hostSharedConfig
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
      nixosModules = lib'.importModules (lib.filesToAttr ./modules/nixos);

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

              path = ./users/home-manager/${name};
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
                  targets.genericLinux.enable = true;
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

      # Extending home-manager with my custom modules, if anyone cares.
      homeModules =
        lib'.importModules (lib'.filesToAttr ./modules/home-manager);


    };
}
