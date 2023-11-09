{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.hardware.language.en;
in
{
  options.modules.hardware.language.en = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # Set the computer language.
    # Note that this is already the default.
    i18n.defaultLocale = "en_US.UTF-8";

  };
}
