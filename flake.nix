{
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

    hyprland.url = "github:hyprwm/Hyprland";

    disko.inputs.nixpkgs.follows = "nixpkgs";

    maiden.url = "git+file:///persist/home/enmeei/projects/maiden";
    flavours.url = "git+file:///persist/home/enmeei/projects/flavours";
    zelda.url = "git+file:///persist/home/enmeei/projects/zelda";

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-schemas.url = github:DeterminateSystems/flake-schemas;
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }: let
    lib =
      inputs.nixpkgs.lib.extend
      (self: super: {
        my = import ./lib {
          inherit inputs;
          lib = self;
        };
      });
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs.lib = lib;
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
