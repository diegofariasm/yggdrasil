{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable the hyprland desktop";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      rofi-wayland
      yggdrasil-eww
      hyprpicker
      swww
      hyprpicker
    ];
  };
}
