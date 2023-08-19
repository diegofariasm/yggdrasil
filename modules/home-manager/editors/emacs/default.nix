{ config, options, lib, pkgs, ... }:

let
  cfg = config.modules.editors.emacs;
in
{
  options.modules.editors.emacs = {
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

    # Install the emacs binary
    home.packages = with pkgs; [
      emacs
    ];

  };
}
