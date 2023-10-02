{ pkgs, config, inputs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.hyprland;


in
{
  options.modules.desktop.hyprland = { enable = mkBoolOpt false; };

  imports = [
    inputs.hyprland.nixosModules.default
  ];

  config = mkIf cfg.enable {

    fonts = {
      packages = with pkgs; [
        # nerdfonts
        (nerdfonts.override {
          fonts = [
            "Iosevka"
          ];
        })
      ];
    };

    programs = {
      hyprland = {
        enable = true;
        xwayland = {
          enable = true;
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
        hyprpaper
        hyprpicker
        eww-wayland
        rofi-wayland
        wl-clipboard
      ];
    };
  };
}
