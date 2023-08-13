{ lib, ... }:
with lib;
with my;
rec {

  getSecret = path: ../secrets/${path};

  getUsers = users:
    let
      userModules = filesToAttr ../users;
      invalidUsernames = [ "config" "modules" ];

      users' = filterAttrs (n: _: !elem n invalidUsernames && elem n users) userModules;
      userList = attrNames users';

      nonExistentUsers = filter (name: !elem name userList) users;
    in
    trivial.throwIfNot ((length nonExistentUsers) == 0)
      "There are no users ${concatMapStringsSep ", " (u: "'${u}'") nonExistentUsers}."
      (r: r)
      users';

  getUser = user:
    getAttr user (getUsers [ user ]);

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
