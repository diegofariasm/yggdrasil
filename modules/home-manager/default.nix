# These are some of the defaults for every user.
# For example, we set up auto mount and the nix-index utils.
{ pkgs, ... }:
{
  # This set's up nix-locate with a automatic
  # download of a pre made database.
  programs.nix-index = {
    enable = true;
  };
  # Put the database in the user directory
  home.file = {
    ".cache/nix-index" = {
      source = pkgs.nix-index-database;
    };
  };
  # Auto mount the drives
  # And also notify when they are mounted.
  services = {
    udiskie = {
      enable = true;
      notify = true;
      autoMount = true;
    };
  };


}
