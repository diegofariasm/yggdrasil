{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.apps.logseq;
in {
  options.modules.desktop.apps.logseq = {
    enable = lib.mkOption {
      description = ''
        Whether to install logseq
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      logseq
    ];
  };
}
