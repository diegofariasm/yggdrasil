{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.suckless.dmenu;
in {
  options.modules.desktop.suckless.dmenu = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        dmenu = prev.dmenu.overrideAttrs (old: {
          src = pkgs.fetchzip {
            url = "https://github.com/fushiii/dmenu/archive/master.tar.gz";
            sha256 = "loZXbHFTsfXI29AiYhb/InudRJONDeoIbc2aSmYqqBM=";
          };
        });
      })
    ];
    user.packages = with pkgs; [
      dmenu
    ];
  };
}
