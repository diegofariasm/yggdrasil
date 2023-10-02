{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.term.kitty;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.term.kitty = {
    enable = lib.mkOption {
      description = ''
        Wheter to install kitty.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
        settings = {
          window_padding_width = 16;
          confirm_os_window_close = 0;
          # The most annoying thing in the world.
          # I know i did something wrong, no need to shame me.
          enable_audio_bell = false;
        };
      };
    };
  };
}
