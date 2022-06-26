{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.suckless.dmenu;
in {
  options.modules.desktop.suckless.dmenu = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        dmenu = prev.dmenu.overrideAttrs (old: {
          src = ./src;
        });
      })
    ];
    user.packages = with pkgs; [
      dmenu
    ];
  };
}
