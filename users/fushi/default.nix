{ lib, pkgs, config, options, ... }:

with lib;
with lib.my;

let
  user = "fushi";
in
{
  users.users."${user}" = {
    group = "users";
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
    description = "My personal account.";
    hashedPassword = "$6$YNJGW9lqQz5ccudx$NZnn/GlUXbeoyu6mD7/LLuqVMCd4v8pDmW0xEpMLXcv9gcFqZ24NDpkJxxgCCXbLkSCBiLJ9UdqUBKll4BvAO/";
  };

  home-manager.users."fushi" = { pkgs, config, ... }: {

    home.packages = with pkgs; [
      kitty
    ];

    # TODO: find out why the modules aren't found anywhere.
    #home.mutableFile = {
    #  ".config/nvim" = {
    #    url = "https://github.com/fushiii/nyoom.nvim";
    #    type = "git";
    #  };
    #};

    home.stateVersion = "23.11";
  };
}
