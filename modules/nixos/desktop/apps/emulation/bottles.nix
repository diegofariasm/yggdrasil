{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.desktop.apps.emulation.bottles;
in {
  options.modules.desktop.apps.emulation.bottles.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable bottles";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
