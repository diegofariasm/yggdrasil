{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.browser.brave;
in {
  options.modules.desktop.browser.brave = {
    enable = lib.mkOption {
      description = ''
        Whether to install brave.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brave
    ];
  };
}
