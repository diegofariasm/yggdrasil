{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.term.st;
in
{
  options.modules.desktop.term.st = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        st = prev.st.overrideAttrs (oldAttrs: {
          src = builtins.fetchTarball {
            url = "https://github.com/fushiii/st/archive/ff637e2faf9e2a57d2969ecdfc7d0d47a3ed2060.tar.gz";
            sha256 = "0rfs5gafrx41c9pp0gpy2lyj7vs5c61prnpdjzpyala8b5l6jv0r";
          };
          buildInputs = with pkgs; with xorg; oldAttrs.buildInputs ++ [
            harfbuzz
            libXcursor
          ];
        });
      })
    ];
    home.packages = with pkgs; [
      st
    ];
  };
}
