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
          src = pkgs.fetchzip {
            url = "https://github.com/fushiii/st/archive/master.tar.gz";
            sha256 = "NO4ShwfZQD9aTwPYtE8ULBbZ1Hld6oV9Ok9W1MPwQi8=";
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
