{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.suckless.st;
in {
  options.modules.desktop.suckless.st = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        st = prev.st.overrideAttrs (oldAttrs: {
          src = ./src;
          buildInputs = oldAttrs.buildInputs ++ [pkgs.harfbuzz];
        });
      })
    ];
    user.packages = with pkgs; [
      st
    ];
  };
}
