# This is just a library intended solely for this flake.
# It is expected to use the nixpkgs library with `lib/default.nix`.

{ lib, ... }:
with lib;
with my;
rec {
  # This is only used for home-manager users without a NixOS user counterpart.
  mapHomeManagerUser = user: settings:
    let
      homeDirectory = "/home/${user}";
      defaultUserConfig = {
        extraGroups = mkDefault [ "wheel" ];
        createHome = mkDefault true;
        home = mkDefault homeDirectory;
        isNormalUser = mkForce true;
      };
    in
    {
      imports = [
        { 
          users.users."${user}" = defaultUserConfig;
         }
      ];

      home-manager.users."${user}" = { ... }: {
        imports = [ (getUser "home-manager" user) ];
      };
      users.users."${user}" = settings;
    };

  getSecret = path: ../secrets/${path};

  isInternal = config: config ? _isfoodogsquaredcustom && config._isfoodogsquaredcustom;

  getUsers = users:
    let
      userModules = filesToAttr ../users;
      invalidUsernames = [ 
        "config" "modules" 
      ];

      users' = filterAttrs (n: _: !elem n invalidUsernames && elem n users) userModules;
      userList = attrNames users';

      nonExistentUsers = filter (name: !elem name userList) users;
    in
    trivial.throwIfNot ((length nonExistentUsers) == 0)
      "there are no users ${concatMapStringsSep ", " (u: "'${u}'") nonExistentUsers}"
      (r: r)
      users';

  getUser =  user:
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