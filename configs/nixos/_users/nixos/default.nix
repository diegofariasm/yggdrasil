# This is the user usually used for installers. Don't treat it like a normal
# user, pls. It will override several things just to teach you a lesson. :)
{pkgs, ...}: {
  users.users.nixos = {
    password = "nixos";
    description = "default";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  nix = {
    gc.automatic = true;
    optimise.automatic = true;

    # Please see `nix-conf.5` manual for more details.
    settings = {
      # All to make improvement for using Nix.
      trusted-users = ["root" "@wheel"];
      allow-import-from-derivation = true;
      allow-dirty = true;
      auto-optimise-store = true;
      sandbox = true;

      # Set several binary caches.
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    binutils
    coreutils
    moreutils
    neovim
    whois
    jq
    git
    manix

    # The coreutils replacement.
    ripgrep
    fd
    bat
  ];
}
