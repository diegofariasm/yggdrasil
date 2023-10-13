# This is just a library intended solely for this flake.
# It is expected to use the nixpkgs library with `lib/default.nix`.
{ lib }:

rec {
  # This is only used for home-manager users without a NixOS user counterpart.
  mapHomeManagerUser = user: settings:
    let
      homeDirectory = "/home/${user}";
      defaultUserConfig = {
        extraGroups = lib.mkDefault [ "wheel" ];
        createHome = lib.mkDefault true;
        home = lib.mkDefault homeDirectory;
        isNormalUser = lib.mkForce true;
      };
    in
    ({ lib, ... }: {
      home-manager.users."${user}" = { ... }: {
        imports = [ (getUser "home-manager" user) ];
      };

      users.users."${user}" = lib.mkMerge [
        defaultUserConfig
        settings
      ];
    });

  getSecret = path: ../secrets/${path};

  isInternal = config: config ? _isfoodogsquaredcustom && config._isfoodogsquaredcustom;

  getUsers = users:
    let
      userModules = lib.filesToAttr ../users;
      invalidUsernames = [ "config" "modules" ];

      users' = lib.removeAttrs userModules invalidUsernames;
      userList = lib.attrNames users';

      nonExistentUsers = lib.filter (name: !lib.elem name userList) users;
    in
    lib.trivial.throwIfNot ((lib.length nonExistentUsers) == 0)
      "There are no users ${lib.concatMapStringsSep ", " (u: "'${u}'") nonExistentUsers}"
      (r: r)
      users';

  getUser = user:  ../users/${user};

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
