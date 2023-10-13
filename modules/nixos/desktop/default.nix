{ config, options, lib, pkgs, ... }:



let
  cfg = config.modules.desktop;
in
{
  config = lib.mkIf config.services.xserver.enable {
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
