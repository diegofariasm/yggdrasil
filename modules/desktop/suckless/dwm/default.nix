{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.suckless.dwm;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.suckless.dwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        dwm = prev.dwm.overrideAttrs (old: {
          src = ./src;
          nativeBuildInputs = with pkgs; [xorg.libX11 imlib2];
        });
      })
    ];

    services = {
      xserver = {
        enable = true;
        displayManager = {
          lightdm.enable = true;
        };
        windowManager.dwm.enable = true;
      };
    };
    user.packages = with pkgs; [
      sxhkd
      xclip
      xsel
    ];
    fonts.fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "DroidSansMono"
          "Iosevka"
          "SourceCodePro"
          "Hack"
          "Meslo"
          "Overpass"
        ];
      })
    ];
    home.configFile."alacritty" = {
      source = "${configDir}/dwm/alacritty";
      recursive = true;
    };

    home.configFile."dmenu" = {
      source = "${configDir}/dwm/dmenu";
      recursive = true;
    };
    home.configFile."dwm" = {
      source = "${configDir}/dwm/dwm";
      recursive = true;
    };
  };
}
