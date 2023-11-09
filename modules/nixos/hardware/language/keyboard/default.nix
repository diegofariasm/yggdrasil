{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.hardware.language.keyboard;
in
{
  options.modules.hardware.language.keyboard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # This sets some sensible
    # defaults for the keyboard configuration.
    services.xserver = {
      autoRepeatInterval = 20;
    };
    services.xserver.autoRepeatDelay = 300;

    environment.systemPackages = with pkgs; [
      btop
    ];
  };
}
