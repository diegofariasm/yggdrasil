{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.bun;
in
{
  options.modules.dev.bun = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        my.bun
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
