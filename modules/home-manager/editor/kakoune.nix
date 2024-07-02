{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.editor.kakoune;
in {
  options.modules.editor.kakoune = {
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
      ];
    }
    (lib.mkIf config.modules.roots.enable {
      xdg.configFile = {
        kak.source = "${config.modules.roots.directory}/.config/kak";
      };
    })
  ]);
}
