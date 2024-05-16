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

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = with pkgs; [
        yggdrasil-kak-lsp
        yggdrasil-kakoune
        kak-tree-sitter
        kak-popup
        ktsctl
        sad
        kakounePlugins.parinfer-rust
        tmux
        delta
        ripgrep
        rainbower
      ];
    }
    (lib.mkIf config.modules.roots.enable {
      xdg.configFile = {
        kak.source = "${config.modules.roots.directory}/.config/kak";
      };
    })
  ]);
}
