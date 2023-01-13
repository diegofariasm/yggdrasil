{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.term.st;
in {
  options.modules.desktop.term.st = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        st = prev.st.overrideAttrs (oldAttrs: {
          src = builtins.fetchTarball {
            url = "https://github.com/fushiii/st/archive/8fbeaa97313629102c1dde6d053cce953cb23dd3.tar.gz";
            sha256 = "1rfdkwscfx357ii51aizhz1qb3bz607924hs97v2w1y81i83srhp";
          };
          buildInputs = oldAttrs.buildInputs ++ [pkgs.harfbuzz];
        });
      })
    ];
    home.packages = with pkgs; [
      st
    ];
  };
}
