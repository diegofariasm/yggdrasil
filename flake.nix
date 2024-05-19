{
  nixConfig = {
    extra-substituters = "https://nix-community.cachix.org https://yggdrasil.cachix.org";
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= yggdrasil.cachix.org-1:NJ6EZvfzu3iwnqMW6E0Wmd+ZR262OA5+9bZQrWm3imo=";
    commit-lockfile-summary = "flake.lock: update inputs";
  };

  inputs = {
    nixpkgs.follows = "nixos-unstable";

    nixos-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    home-manager.follows = "home-manager-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";

    # We're using these libraries for other functions.
    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";

    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {flake-parts, ...}: let
    lib =
      inputs.nixpkgs.lib.extend
      (self: _super: {
        my = import ./lib {
          inherit inputs;
          lib = self;
        };
      });
  in
    flake-parts.lib.mkFlake
    {
      inherit inputs;
      specialArgs = {
        inherit lib;
      };
    }
    {
      systems = ["x86_64-linux"];
      imports = [
        ./modules/flake-parts
        ./configs/flake-parts
      ];
    };
}
