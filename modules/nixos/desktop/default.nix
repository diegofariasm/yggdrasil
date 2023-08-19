{ config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  config = mkIf config.services.xserver.enable {

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        ubuntu_font_family
        jetbrains-mono
        dejavu_fonts
        symbola
      ];
    };

  };
}
