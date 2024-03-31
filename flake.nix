{
  nixConfig = {
    extra-substituters = "https://nix-community.cachix.org";
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
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

    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # The rice machine.
    # I have been using it for a while, nothing beats it.
    hyprland.url = "github:hyprwm/Hyprland";

    # kak-rainbower.url = "git+file:///home/diegofariasm/projects/kak-rainbower";
    # maiden.url = "git+file:///home/diegofariasm/projects/maiden";
    # flavours.url = "git+file:///home/diegofariasm/projects/flavours";
    # zelda.url = "git+file:///home/diegofariasm/projects/zelda";

    kak-rainbower.url = "git+ssh://git@github.com/diegofariasm/kak-rainbower";
    maiden.url = "git+ssh://git@github.com/diegofariasm/maiden";
    flavours.url = "git+ssh://git@github.com/diegofariasm/flavours";
    zelda.url = "git+ssh://git@github.com/diegofariasm/zelda";
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
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = {
        lib = lib;
      };
    }
    {
      systems = ["x86_64-linux"];
      imports =
        [
          ./modules/flake-parts
        ]
        ++ lib.my.modulesToList (lib.my.filesToAttr ./configs/flake-parts);
    };
}
