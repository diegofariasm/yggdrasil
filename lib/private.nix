# This is just a library intended solely for this flake.
# It is expected to use the nixpkgs library with `lib/default.nix`.
{ lib }:

rec {

  getSecret = path: ../secrets/${path};

  getUser = user: ../users/${user};

  # Import modules with a set blocklist.
  importModules = attrs:
    let
      blocklist = [
        # The modules under this attribute are often incomplete and needing
        # very specific requirements that is 99% going to be absent from the
        # outside so we're not going to export it.
        "tasks"

        # Profiles are often specific to this project so there's not much point
        # in exporting these.
        "profiles"
      ];
    in
    lib.attrsets.removeAttrs (lib.mapAttrsRecursive (_: sopsFile: import sopsFile) attrs) blocklist;
}

