{
  pkgs ? import <nixpkgs> {},
  overrides ? (_self: _super: {}),
}:
with pkgs; let
  packages = self: let
    callPackage = newScope self;
  in {
    icomoon = callPackage ./icomoon {};
    imagecolorizer = callPackage ./imagecolorizer {};
    recolor = callPackage ./recolor {};
    kak-popup = callPackage ./kak-popup {};
    ktsctl = callPackage ./ktsctl {};
    kak-tree-sitter = callPackage ./kak-tree-sitter {};
  };
in
  lib.fix' (lib.extends overrides packages)
