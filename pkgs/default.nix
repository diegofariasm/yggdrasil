{ pkgs ? import <nixpkgs> { }, overrides ? (self: super: { }) }:

with pkgs;

let
  packages = self:
    let callPackage = newScope self;
    in rec {
      icomoon = callPackage ./icomoon { };
    };
in
lib.fix' (lib.extends overrides packages)
