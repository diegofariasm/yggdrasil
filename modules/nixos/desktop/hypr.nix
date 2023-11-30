{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.desktop.hypr;
in
{
  options.modules.desktop.hypr = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  imports = [
    inputs.hyprland.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Iosevka"
        ];
      })
    ];

    programs.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    environment.systemPackages = with pkgs; [ eww-wayland rofi-wayland wl-clipboard hyprpaper jq socat ];

  };
}
