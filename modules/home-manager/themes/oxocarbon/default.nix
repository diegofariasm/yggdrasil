{ options, config, inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.theme;
in
{
  config = mkIf (cfg.active == "oxocarbon") {

    modules.theme.wallpaper = mkDefault ./config/wallpaper.jpg;

    # Set the theme for the applications.
    stylix.base16Scheme = if cfg.isLight then ./config/light.yaml else ./config/dark.yaml;

  };

}
