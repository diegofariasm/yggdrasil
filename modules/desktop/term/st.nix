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
            url = "https://github.com/fushiii/st/archive/21345f72bc9a0a09b9f92da9061b36ce4cb5fd45.tar.gz";
            sha256 = "11as4ph8dwfdnfg1kq9sc03rw4l86bz3gridm3dz3nf2v9kg57hg";
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
