{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.hypr;
in {
  options.modules.desktop.hypr.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable the hypr desktop";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      rofi-wayland
      eww-wayland
      hyprpicker
      swww
    ];
  };
}
