{
  inputs,
  lib,
  ...
}: {
  imports = [
    ./dev.nix
    ./packages.nix
    ./templates.nix

    # The environment configurations.
    ./home-manager.nix
    ./nixos.nix
  ];

  _module.args = {
    # This will be shared among NixOS and home-manager configurations.
    defaultNixConf = {
      config,
      lib,
      pkgs,
      ...
    }: {
      # Set the package for generating the configuration.
      nix.package = lib.mkDefault pkgs.nixStable;

      # Set the configurations for the package manager.
      nix.settings = {
        # They already have root acess anyway
        trusted-users = [
          "root"
          "@wheel"
        ];

        # Set several binary caches.
        substituters = [
          "https://yggdrasil.cachix.org"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "yggdrasil.cachix.org-1:NJ6EZvfzu3iwnqMW6E0Wmd+ZR262OA5+9bZQrWm3imo="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        # Sane config for the package manager.
        # TODO: Remove this after nix-command and flakes has been considered
        # stable.
        #
        # Since we're using flakes to make this possible, we need it. Plus, the
        # UX of Nix CLI is becoming closer to Guix's which is a nice bonus.
        experimental-features = ["nix-command" "flakes" "repl-flake"];
        auto-optimise-store = lib.mkDefault true;
      };

      # Stallman-senpai will be disappointed.
      nixpkgs.config.allowUnfree = true;

      # Extend nixpkgs with our overlays except for the NixOS-focused modules
      # here.
      nixpkgs.overlays = lib.attrValues inputs.self.overlays;
    };

    defaultOverlays = lib.attrValues inputs.self.overlays;
  };

  perSystem = {
    lib,
    system,
    ...
  }: {
    _module.args = {
      # nixpkgs for this module should be used as less as possible especially
      # for building NixOS and home-manager systems.
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays =
          lib.attrValues inputs.self.overlays
          ++ [
            inputs.nur.overlay
          ];
      };
    };
  };
}
