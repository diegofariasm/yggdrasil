{ lib, pkgs, ... }:

let
  user = "diegofariasm";
  homeManagerUser = lib.getUser "home-manager" user;
in
{
  users.users = {
    "${user}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
      hashedPassword = "$y$j9T$4kH1DpfluPRI4kjUG3eC..$O56uu5IvPNqoYDZ3zh95dNbiqHo7iQHcszhhVDdipo9";
    };
  };

  # Import the user related options.
  home-manager.users.${user} = { lib, ... }: {
    imports = [
      homeManagerUser
    ];
  };
}

