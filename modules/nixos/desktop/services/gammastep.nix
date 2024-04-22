{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.services.gammastep;
in {
  options.modules.desktop.services.gammastep = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the gammastep service.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.gammastep = {
      description = "gammastep daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.gammastep}/bin/gammastep'';
      };
    };
  };
}
