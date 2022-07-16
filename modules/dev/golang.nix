# modules/dev/node.nix --- https://nodejs.org/en/
#
# JS is one of those "when it's good, it's alright, when it's bad, it's a
# disaster" languages.
{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.go;
in
{
  options.modules.dev.go = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (
      mkIf cfg.enable {
        home.packages = with pkgs; [
          go
          gopls # Language Server
          go-outline
        ];
      }
    )

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
