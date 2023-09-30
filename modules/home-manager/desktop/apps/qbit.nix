{ config, lib, pkgs, ... }:

let cfg = config.modules.desktop.apps.qbit;
in {
  options.modules.desktop.apps.qbit = {
    enable = lib.mkOption {
      description = ''
        Wheter to install qbit.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ qbittorrent ]; };
}
