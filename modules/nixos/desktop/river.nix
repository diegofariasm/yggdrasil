{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.river;
in {
  options.modules.desktop.river.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable the river desktop";

  config = lib.mkIf cfg.enable {
    programs.river = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      river-tag-overlay
      rofi-wayland
      yggdrasil-eww
      swww
    ];
  };
}
