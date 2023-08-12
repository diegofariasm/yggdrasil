{ inputs
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  name = builtins.getEnv "USER";

  # All of my personal modules.
  # Note: they are pretty unstable, as i will
  # be making changes as i learn more nix.
  homeModules = (mapModulesRec' (toString ./modules/home) import);
  nixosModules = (mapModulesRec' (toString ./modules/nixos) import);

in
{
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    # Nixos modules
    ++ nixosModules;

  # Home manager modules
  maiden.imports = homeModules;

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment.variables = {
    DOTFILES = config.dotfiles.dir;
    DOTFILES_BIN = config.dotfiles.binDir;
  };

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix =
    let
      filteredInputs = filterAttrs (n: _: n != "self") inputs;
      nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
      registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in
    {
      package = pkgs.nixVersions.stable;
      extraOptions = "experimental-features = nix-command flakes";
      nixPath =
        nixPathInputs
        ++ [
          "dotfiles=${config.dotfiles.dir}"
          "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        ];
      registry = registryInputs // { dotfiles.flake = inputs.self; };
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        auto-optimise-store = true;
      };
    };
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "21.05";

  ## Some reasonable, global defaults
  # This is here to appease 'nix flake check' for generic hosts with no
  # hardware-configuration.nix or fileSystem config.
  fileSystems."/".device = mkDefault "/dev/disk/by-label/nix-root";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so we enforce
  # this default behavior here.
  networking.useDHCP = mkDefault false;

  boot = {
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 5;
      systemd-boot.enable = mkDefault true;
    };
  };

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    git
    unzip
    killall
    treefmt
    rnix-lsp
    nixpkgs-fmt
    cached-nix-shell
    update-nix-fetchgit
  ];
}
