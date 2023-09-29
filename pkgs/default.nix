{ pkgs ? import <nixpkgs> { }, overrides ? (self: super: { }) }:

with pkgs;

let
  packages = self:
    let callPackage = newScope self;
    in {
      vinegar = callPackage ./vinegar { wine = wineWowPackages.staging; };
      fonts = {
        icomoon = callPackage ./fonts/icomoon { };
        san-francisco = callPackage ./fonts/san-francisco { };
      };

    };
in lib.fix' (lib.extends overrides packages)
