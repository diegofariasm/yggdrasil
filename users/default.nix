{ config, pkgs, ... }:

let
  stateVersion = "23.11";
in
{
  # Make the state version available here.
  # Note: without this, home-manager doesn't work with flakes.
  home = {
    stateVersion = stateVersion;
  };
}
