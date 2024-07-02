{
  config,
  pkgs,
  lib,
  ...
}: let
  one = config.modules.desktop.app.emulation.playstation.one;
  two = config.modules.desktop.app.emulation.playstation.two;
in {
  options.modules.desktop.app.emulation.playstation = {
    one.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable emulation for playstation one";
    two.enable = lib.my.mkOpt' lib.types.bool false "Whether to enable emulation for playstation two";
  };
  config = lib.mkMerge [
    (lib.mkIf one.enable {
      environment.systemPackages = with pkgs; [
        pcsxr
      ];
    })
    (lib.mkIf one.enable {
      environment.systemPackages = with pkgs; [
        pcsx2
      ];
    })
  ];
}
