{ lib, ... }:
with lib;
with my;
{

  getSecret = path: ../secrets/${path};

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
    filterAttrs (n: v: !elem n blocklist) (mapAttrsRecursive (_: sopsFile: import sopsFile) attrs);
}
