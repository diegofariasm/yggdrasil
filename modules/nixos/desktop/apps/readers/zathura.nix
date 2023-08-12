{ config
, options
, inputs
, lib
, pkgs
, ...
}:
with builtins;
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.readers.zathura;
in
{
  options.modules.desktop.apps.readers.zathura = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      zathura
    ];
  };
}

