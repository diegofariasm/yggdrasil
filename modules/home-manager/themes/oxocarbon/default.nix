{ options, config, inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "oxocarbon") {

    modules.theme.wallpaper = mkDefault ./config/wallpaper.jpg;

    stylix.base16Scheme = ./config/oxocarbon.yaml;

  };

}
