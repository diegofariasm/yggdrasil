{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in
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

    # Clean up leftovers, as much as we can
    # system.userActivationScripts.cleanupHome = ''
    #   pushd "${config.user.home}"
    #   rm -rf .compose-cache .nv .pki .dbus .fehbg
    #   [ -s .xsession-errors ] || rm -f .xsession-errors*
    #   popd
    # '';
  };
}
