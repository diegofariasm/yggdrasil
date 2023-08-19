{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.editors.code;
in
{
  options.modules.desktop.apps.editors.code = {
    enable = lib.mkOption {
      description = ''
        Wheter to install code.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = ''
        The package for code.
      '';
      default = pkgs.vscode;
    };

  };
  config = lib.mkIf cfg.enable {
    home.packages = with cfg; [
      # The said package for the code module.
      # Should default to visual studio code.
      package
    ];
  };
}
