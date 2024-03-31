{
  pkgs ? import <nixpkgs> {},
  overrides ? (_self: _super: {}),
}:
with pkgs; let
  packages = self: let
    callPackage = newScope self;
  in {
    san-francisco = callPackage ./fonts/san-francisco {};
    icomoon = callPackage ./fonts/icomoon {};
    imagecolorizer = callPackage ./imagecolorizer {};
    recolor = callPackage ./recolor {};
  };
in
  lib.fix' (lib.extends overrides packages)
