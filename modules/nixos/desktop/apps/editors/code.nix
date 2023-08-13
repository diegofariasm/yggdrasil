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
  cfg = config.modules.desktop.apps.editors.code;
in
{
  options.modules.desktop.apps.editors.code = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # TODO: add back config, make it mutable
    # as well.
    home.packages = with pkgs; [
      vscode
      nixpkgs-fmt
    ];
  };
}

