{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.obsidian;
in
{
  options.modules.desktop.apps.obsidian = {
    enable = lib.mkOption {
      description = ''
        Wheter to install obsidian.
        A Markdown notetaking app.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
