{
  config,
  lib,
  ...
}: let
  cfg = config.modules.hardware.language.keyboard.br;
in {
  options.modules.hardware.language.keyboard.br.enable = lib.my.mkOpt lib.types.bool false;

  config = lib.mkIf cfg.enable {
    # This sets some sensible
    # defaults for the keyboard configuration.
    services.xserver.xkb = {
      layout = "br";
      options = "caps:escape";
    };

    # This sets up the tty.
    # Not generally used, but good.
    console.keyMap = "br-abnt2";
  };
}
