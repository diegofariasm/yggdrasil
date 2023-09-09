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

}
