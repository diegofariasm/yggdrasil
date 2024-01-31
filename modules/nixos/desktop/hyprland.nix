{ pkgs, config, inputs, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland.enable = lib.my.mkOpt' lib.types.bool false "Wheter to enable the hyprland desktop";

  # imports = [
  #   inputs.hyprland.nixosModules.default
  # ];

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      rofi-wayland
      eww-wayland
      hyprpicker
      hyprpaper
    ];

  };
}
