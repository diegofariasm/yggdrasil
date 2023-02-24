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
            url = "https://github.com/fushiii/st/archive/d47a8e6b16b02dd44a3bdce393b7b3255314c2e6.tar.gz";
            sha256 = "1yd47y4hqg3xrrbm7x9lkqqfnc6c9q25cvmil8l78vi4q9j8lcrk";
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
