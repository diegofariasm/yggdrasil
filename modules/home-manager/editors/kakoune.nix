{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.editors.kakoune;
in {
  options.modules.editors.kakoune = {
    enable = lib.mkOption {
      description = ''
        Whether to install kakoune.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        kak-lsp
        kakoune
      ];
      persist = {
        directories = [
          ".config/kak"
        ];
      };
    };
  };
}
