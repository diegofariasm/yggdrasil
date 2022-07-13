# modules/browser/brave.nix --- https://publishers.basicattentiontoken.org
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.chrome;
in {
  options.modules.desktop.browsers.chrome= {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      google-chrome
        
    ];
  };
}
