{pkgs ? import <nixpkgs> {}}:
with pkgs; {
  basic = callPackage ./basic {};
}
