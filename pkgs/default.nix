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
      imagecolorizer = callPackage ./imagecolorizer { };
      pywalfox = callPackage ./pywalfox { };
      recolor = callPackage ./recolor { };
    };
in
lib.fix' (lib.extends overrides packages)
