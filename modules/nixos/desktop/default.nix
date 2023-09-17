{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop;
in
{
  config = mkIf config.services.xserver.enable {
    assertions = [

      {
        assertion =
          let srv = config.services;
          in
          srv.xserver.enable ||
          srv.hypr.enable ||
          !(anyAttrs
            (n: v: isAttrs v &&
            anyAttrs (n: v: isAttrs v && v.enable))
            cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    environment = {
      # Some common packages.
      # These generally are meant for things
      # that shouldn't too much, like notifcations and etc.
      systemPackages = with pkgs; [
        libnotify
        brightnessctl
      ];
    };

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        ubuntu_font_family
        dejavu_fonts
        symbola
      ];
    };

  };
}
