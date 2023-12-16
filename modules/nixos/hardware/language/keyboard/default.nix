{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.hardware.language.keyboard;
in
{
  options.modules.hardware.language.keyboard.enable = lib.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    # This sets some sensible
    # defaults for the keyboard configuration.
    services.xserver = {
      autoRepeatInterval = 20;
    };
    services.xserver.autoRepeatDelay = 300;

  };
}
