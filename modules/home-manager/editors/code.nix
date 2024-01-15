{ config, pkgs, lib, ... }:

let cfg = config.modules.editors.code;
in
{
  options.modules.editors.code = {
    enable = lib.mkOption {
      description = ''
        Whether to install code.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vscodium
    ];
  };
}
