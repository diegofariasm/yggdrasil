{
  pkgs,
  config,
  lib,
  options,
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
          src = pkgs.fetchzip {
            url = "https://github.com/fushiii/dwm/archive/master.tar.gz";
            sha256 = "sUm28yHGlj9mtlAh5CIk2Nlo4r7QHaFm//I5GDF0vAA=";
          };
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
      pavucontrol # Audio
      sxhkd # Keybinds

      xclip
      xsel
      my.luastatus
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

    home.configFile."dwm" = {
      source = "${configDir}/dwm/dwm";
      recursive = true;
    };
  };
}
