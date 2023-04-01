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
in
{
  options.modules.desktop.hypr = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    nixpkgs.overlays = [
      (final: prev: {
        hyprland = prev.hyprland.overrideAttrs (oldAttrs: {
          name = "hyprland";
        });
      })
    ];

    home.packages = with pkgs; [
      eww
      hyprland
    ];
  };
}
