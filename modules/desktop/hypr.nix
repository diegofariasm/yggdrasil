{ pkgs
, config
, inputs
, lib
, options
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hypr;
  configDir = config.dotfiles.configDir;
  binDir = config.dotfiles.binDir;
  inherit(inputs) hyprland;
in
{
  options.modules.desktop.hypr = { enable = mkBoolOpt false; };
  imports = [
        hyprland.nixosModules.default
  ];
  config = mkIf cfg.enable {

    # Display manager
    services.xserver = {
      enable = true;
      displayManager.lightdm = {
        enable = true;
      };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    programs.dconf.enable = true;
    programs.hyprland.enable = true;

    home = {
      packages = with pkgs; [
        foot
        hyprland
        hyprpaper
        eww-wayland
      ];
      configFile = {
        "hypr" = {
          source = "${configDir}/hypr";
          recursive = true;
        };
        "hypr/scripts" = {
          source = "${binDir}/hypr";
        };
      };
    };
  };
}
