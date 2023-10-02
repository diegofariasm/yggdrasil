{ config, pkgs, lib, ... }:

let cfg = config.modules.editors.helix;
in
{
  options.modules.editors.helix = {
    enable = lib.mkOption {
      description = ''
        Wheter to install emacs.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    programs = {
      helix = {
        enable = true;
        settings = {
          editor = {
            mouse = false;
            auto-pairs = true;
            soft-wrap.enable = true;
            file-picker.hidden = false;
            lsp.display-messages = true;
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
            indent-guides = {
              render = true;
              character = "▏";
              skip-levels = 1;
                          };
          };
        };
        languages = {
          language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "nixpkgs-fmt";
            }
            {
              name = "rust";
              auto-format = true;
              config.check.command = "clippy";
              formatter.command = "rustfmt";
            }
          ];
        };
      };
    };
  };
}
