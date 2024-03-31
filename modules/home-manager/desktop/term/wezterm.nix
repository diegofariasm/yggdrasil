{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.term.wezterm;
in {
  options.modules.desktop.term.wezterm = {
    enable = lib.mkOption {
      description = ''
        Whether to install wezterm.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        wezterm
      ];
    };
  };
}
