{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland.enable = lib.mkOpt' lib.types.bool false "Wheter to enable the hyprland desktop";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      rofi-wayland
      eww-wayland
      hyprpicker
      hyprpaper
    ];
  };
}
