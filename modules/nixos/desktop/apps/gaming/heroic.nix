{ pkgs, config, inputs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.gaming.heroic;

in
{
  options.modules.desktop.apps.gaming.heroic = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      heroic
      gogdl
    ];
  };
}
