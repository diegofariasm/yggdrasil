{ lib, pkgs, config, nix-colors, ... }:

let
  cfg = config.modules.theme;
in
{
  config = lib.mkIf (cfg.active == "oxocarbon") {
    modules = {
      theme = {
        wallpaper = lib.mkDefault ./config/wallpaper.jpg;
      };
    };
    stylix.base16Scheme = builtins.toFile "oxocarbon.yaml" (nix-colors.lib.schemeToYAML config.colorScheme);
  };

}
