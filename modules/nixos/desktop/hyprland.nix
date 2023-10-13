{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.desktop.hyprland;


in
{
  options.modules.desktop.hyprland = {   enable = lib.mkOption {
      
     type = lib.types.bool;
      default = false;
      example = true;
    }; };

  imports = [
    inputs.hyprland.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {

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
