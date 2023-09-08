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

    # Removing the manual partitioning part with a little boogie.
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Managing your secrets.
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # We're using these libraries for other functions.
    flake-utils.url = "github:numtide/flake-utils";

    # Managing home configurations.
    home-manager.url = "github:nix-community/home-manager";

    # This is what AUR strives to be.
    nur.url = "github:nix-community/NUR";

    # emacs-overlay.url = "github:nix-community/emacs-overlay";
    # emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

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

      # The order here is important(?).
      overlays = with inputs; [
        # Put my custom packages to be available.
        self.overlays.default

        # Access to NUR.
        nur.overlay

        (final: prev: {
          nix-index-database = final.runCommandLocal "nix-index-database" { } ''
            mkdir -p $out
            ln -s ${
              nix-index-database.legacyPackages.${prev.system}.database
            } $out/files
          '';
        })

      ];

      systems = [ "x86_64-linux" "aarch64-linux" ];

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
        imports = with inputs;
          [
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
            nur.nixosModules.nur
          ] ++ (mapModulesRec' (toString ./modules/nixos) import)
          ++ (mapModulesRec' (toString ./users) import);

        environment.systemPackages = with pkgs; [
          nil
          git
          age
          vim
          sops
          unzip
          nixfmt
          treefmt
          rnix-lsp
          nixpkgs-fmt
          font-manager
          cached-nix-shell
        ];

        # BOOOOOOOOOOOOO! Somebody give me a tomato!
        services.xserver.excludePackages = with pkgs; [ xterm ];

        # Set several paths for the traditional channels.
        nix.nixPath = lib.mapAttrsToList
          (name: source:
            let name' = if (name == "self") then "config" else name;
            in "${name'}=${source}")
          inputs
        ++ [ "/nix/var/nix/profiles/per-user/root/channels" ];

        # The global configuration for the home-manager module.
        home-manager = {
          useUserPackages = lib.mkDefault true;
          useGlobalPkgs = lib.mkDefault true;

          # Make all of the flake inputs
          # available to the home-manager modules.
          # Note: can not use extraArgs here because
          # the 'inherit lib' there will collide with hm.
          extraSpecialArgs = { inherit inputs; };

          sharedModules =
            (mapModulesRec' (toString ./modules/home-manager) import)
            ++ [ userSharedConfig ];
        };

        system = {
          configurationRevision = lib.mkIf (self ? rev) self.rev;
          stateVersion = "21.05";
        };

        boot = {
          # Probably won't see this.
          # That's the magic of ssd's for you.
          plymouth.enable = true;

          loader = {
            systemd-boot = {
              enable = lib.mkDefault true;
              configurationLimit = 5;
            };
            efi.canTouchEfiVariables = lib.mkDefault true;
          };
        };

      };
      # The default config for our home-manager configurations. This is also to
      # be used for sharing modules among home-manager users from NixOS
      # configurations with `nixpkgs.useGlobalPkgs` set to `true` so avoid
      # setting nixpkgs-related options here.
      userSharedConfig = { pkgs, config, lib, ... }: {
        # TODO: find how to import some of the modules
        # in the place where they are needed.
        imports = with inputs; [
          stylix.homeManagerModules.stylix
          sops-nix.homeManagerModules.sops
          nur.hmModules.nur
        ];

        # Enable home-manager.
        # This also makes it able to manage itself.
        programs.home-manager.enable = true;

        home.stateVersion = lib.mkDefault "23.11";
      };

      nixSettingsSharedConfig = { config, lib, pkgs, ... }: {

        # Configure nix and nixpkgs
        environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
        nix =
          let
            filteredInputs = lib.filterAttrs (n: _: n != "self") inputs;
            nixPathInputs = lib.mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
            registryInputs = lib.mapAttrs (_: v: { flake = v; }) filteredInputs;
          in
          {
            package = pkgs.nixFlakes;
            extraOptions = "experimental-features = nix-command flakes";
            nixPath = nixPathInputs ++ [
              "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
              "dotfiles=${config.dotfiles.dir}"
            ];
            registry = registryInputs // { dotfiles.flake = inputs.self; };
            settings = {
              substituters = [
                "https://hyprland.cachix.org"
                "https://nix-community.cachix.org"
              ];
              trusted-public-keys = [
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              ];
              auto-optimise-store = true;
            };
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
                config =
                  lib.mkMerge [{ networking.hostName = lib.mkForce host._name; }];
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
      nixosModules = lib.importModules (lib.filesToAttr ./modules/nixos);

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
                  config.allowUnfree = true;

                  home.username = name;
                  home.homeDirectory =
                    metadata.home-directory or "/home/${config.home.username}";
                };

                programs.home-manager.enable = true;
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
      homeModules = lib.importModules (lib.filesToAttr ./modules/home-manager);

      # In case somebody wants to use my stuff to be included in nixpkgs.
      overlays.default = final: prev: import ./pkgs { pkgs = prev; };

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
                    (lib.mkIf (metadata ? domain)
                      { networking.domain = lib.mkForce metadata.domain; })
                  ];
                })
                hostSharedConfig
                ./hosts/${name}
              ];
            }))
          images');
    };
}
