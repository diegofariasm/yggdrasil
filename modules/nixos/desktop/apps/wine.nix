{ pkgs, config, inputs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.wine;
in {
  options.modules.desktop.apps.wine = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ wineWowPackages.stable ];
      #sessionVariables = [
      #];

    };
  };
}
