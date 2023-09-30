{ config, pkgs, lib, ... }:

let cfg = config.modules.editors.kakoune;
in {
  options.modules.editors.kakoune = {
    enable = lib.mkOption {
      description = ''
        Wheter to install kakoune.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    nixpkgs.overlays = [
      (self: super: {
        kakoune = super.wrapKakoune self.kakoune-unwrapped {
          configure = {
            plugins = with self.kakounePlugins; [ parinfer-rust ];
          };
        };
      })
    ];

    home.packages = with pkgs; [ kak-lsp kakoune ];
  };
}
