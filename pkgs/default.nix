{ pkgs ? import <nixpkgs> { }, overrides ? (self: super: { }) }:

with pkgs;

let
  packages = self:
    let callPackage = newScope self;
    in
    {
      fonts = import ./fonts;
      vinegar = callPackage ./vinegar { wine = wineWowPackages.staging; };
    };
in
lib.fix' (lib.extends overrides packages)
