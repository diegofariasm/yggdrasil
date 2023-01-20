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
            url = "https://github.com/fushiii/st/archive/e3c502ac2c969591fd196313e1b7ab4bd8102ba5.tar.gz";
            sha256 = "199y5xrhrngp1sri4ys9gqvpwl3ap4q2xqx2mcdylf1fsfys62hv";
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
