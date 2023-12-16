{ config, pkgs, lib, ... }:

let cfg = config.modules.editors.codium;
in
{
  options.modules.editors.codium = {
    enable = lib.mkOption {
      description = ''
        Whether to install codium.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ vscodium ];
  };
}
