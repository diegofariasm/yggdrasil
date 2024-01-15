{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.modules.theme.boot.loader.gdm;
  theme = config.modules.theme;
in
{
  options.modules.theme.boot.loader.gdm = {
    enable = lib.my.mkOpt lib.types.bool (theme.enable && theme.autoenable);
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      neofetch
    ];
  };
}
