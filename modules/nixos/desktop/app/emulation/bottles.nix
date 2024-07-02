{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.desktop.app.emulation.bottles;
in {
  options.modules.desktop.app.emulation.bottles.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable bottles";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
