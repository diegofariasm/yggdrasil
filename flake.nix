{

  inputs = {
    # I know NixOS can be stable but we're going cutting edge, baybee! While
    # `nixpkgs-unstable` branch could be faster delivering updates, it is
    # looser when it comes to stability for the entirety of this
    # configuration...
    nixpkgs.follows = "nixos-unstable";

    # ...except we allow other configurations to use other nixpkgs branch so
    # that may not matter anyways.
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # Managing home configurations.
    home-manager.follows = "home-manager-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";

    # We're using these libraries for other functions.
    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";

    impermanence.url = "github:nix-community/impermanence";

    # Generate your NixOS systems to various formats!
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Deploying stuff with Nix. This is becoming a monorepo for everything I
    # need and I'm liking it.
    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixpkgs";

    # Managing your secrets.
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    # Removing the manual partitioning part with a little boogie.
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    flake-schemas.url = github:DeterminateSystems/flake-schemas;

    # Someone had the idea to make the flake outputs be configured as a Nix
    # module and I love them for it.
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    let
      lib = inputs.nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit inputs; lib = self; }; });
    in
    flake-parts.lib.mkFlake { inherit inputs; specialArgs.lib = lib; }
      {
        systems = [ "x86_64-linux"  "aarch64-linux"  ];
        imports = [
          ./modules/flake-parts
        ] ++ lib.my.modulesToList (lib.my.filesToAttr ./configs/flake-parts);
      };
}
