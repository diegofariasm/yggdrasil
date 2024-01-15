{ pkgs ? import <nixpkgs> { }, overrides ? (self: super: { }) }:

with pkgs;

let
  packages = self:
    let callPackage = newScope self;
    in
    {
      fonts = {
        san-francisco = callPackage ./fonts/san-francisco { };
        icomoon = callPackage ./fonts/icomoon { };
      };
      vinegar = callPackage ./vinegar { wine = wineWowPackages.staging; };
      luastatus = callPackage ./luastatus { };
      imagecolorizer = callPackage ./imagecolorizer { };
      pywalfox = callPackage ./pywalfox { };
    };
in
lib.fix' (lib.extends overrides packages)
