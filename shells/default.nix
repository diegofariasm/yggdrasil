{pkgs ? import <nixpkgs> {}}:
with pkgs; {
  install = callPackage ./install.nix {};
}
