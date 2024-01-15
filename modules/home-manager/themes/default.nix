{ config
, pkgs
, lib
, ...
}:
with lib;
with lib.my;
let
  cfg = config.modules.theme;
in
{
  options.modules.theme = {
    enable = mkOpt lib.types.bool false;
    autoenable = mkOpt' lib.types.bool true "Where to auto enable the modules. If this is on, all of modules under themes.* will be enabled.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hello
    ];
  };
}
