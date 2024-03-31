{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.term.kitty;
in {
  options.modules.desktop.term.kitty = {
    enable = lib.mkOption {
      description = ''
        Whether to install kitty.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        kitty
      ];
    };
  };
}
