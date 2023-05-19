{ pkgs
, config
, inputs
, lib
, options
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.dwm;
  configDir = config.dotfiles.configDir;
  binDir = config.dotfiles.binDir;
in
{
  options.modules.desktop.dwm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    nixpkgs.overlays = [
      (final: prev: {
        dwm = prev.dwm.overrideAttrs (oldAttrs: {
          preBuild = ''
            NIX_CFLAGS_COMPILE+="-O3 -march=native"
          '';
          src = builtins.fetchTarball {
            url = "https://github.com/fushiii/dwm/archive/96f6915398e3bfc81fbe37ae588dc7d286985300.tar.gz";
            sha256 = "095dr9hqqq1g8z63nyxpan5dl7f9f6qd9d0f69sly0bfhykgrp6i";
          };
          buildInputs = with pkgs; oldAttrs.buildInputs ++ [
            imlib2
          ];
        });
      })
    ];

    # Display manager
    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      displayManager.lightdm = {
        enable = true;
      };
    };

    home = {
      packages = with pkgs; with my; [
        rofi
        luastatus
      ];
      configFile = {
        "dwm" = {
          source = "${configDir}/dwm";
          recursive = true;
        };
      };
    };
  };
}
