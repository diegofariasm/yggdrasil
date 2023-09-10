{ pkgs ? import <nixpkgs> { }, overrides ? (self: super: { }) }:

with pkgs;

let
  packages = self:
    let callPackage = newScope self;
    in
    {
      icomoon = callPackage ./fonts/icomoon { };
      san-francisco = callPackage ./fonts/san-francisco { };
    };
in
lib.fix' (lib.extends overrides packages)
