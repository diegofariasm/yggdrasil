{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.discord;
in
{
  options.modules.desktop.apps.discord = {
    enable = lib.mkOption {
      description = ''
        Whether to install discord.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; with xfce; [
      discord
    ];
  };
}
