{
  config,
  lib,
  ...
}: let
  cfg = config.modules.theme.oxocarbon;
in {
  options.modules.theme.oxocarbon = {
    enable = lib.my.mkOpt lib.types.bool false;

    luminance = lib.mkOption {
      description = ''
        The luminance of the theme to use.
      '';
      type = lib.types.str;
      default = "dark";
      example = "light";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix.base16Scheme = ./dark.yaml;
  };
}
