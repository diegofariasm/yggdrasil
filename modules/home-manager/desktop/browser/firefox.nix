{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.browser.firefox;
in {
  options.modules.desktop.browser.firefox = {
    enable = lib.mkOption {
      description = ''
        Whether to install firefox.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # firefox
      firefox-devedition
    ];
  };
}
