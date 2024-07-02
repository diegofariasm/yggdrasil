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
    new-york = callPackage ./new-york {};
    apple-emoji = callPackage ./apple-emoji {};
    san-francisco-mono = callPackage ./san-francisco-mono {};
    san-francisco-compact = callPackage ./san-francisco-compact {};
    san-francisco-pro = callPackage ./san-francisco-pro {};
  };
in
  lib.fix' (lib.extends overrides packages)
