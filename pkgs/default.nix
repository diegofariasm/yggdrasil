{ pkgs ? import <nixpkgs> { }, overrides ? (self: super: { }) }:

with pkgs;

let
  packages = self:
    let callPackage = newScope self;
    in
    {
      fonts = import ./fonts;
      vinegar = callPackage ./vinegar { wine = pkgs.wineWowPackages.full; };
    };
in
lib.fix' (lib.extends overrides packages)
