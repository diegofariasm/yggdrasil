{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.surf;
in
{
  options.modules.desktop.browsers.surf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      surf
    ];

  };
}
