{ pkgs
, config
, lib
, options
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.dwm;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.dwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        dwm = prev.dwm.overrideAttrs (old: {
          src = pkgs.fetchzip {
            url = "https://github.com/fushiii/dwm/archive/master.tar.gz";
            sha256 = "GDFQOuh/Xg+Oz8+rmaPHJYwnCyRC4pXh8RmlHh0IJM4=";
          };
          nativeBuildInputs = with pkgs; [ xorg.libX11 imlib2 ];
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

    home.packages = with pkgs; [
      pavucontrol # Audio
      sxhkd # Keybinds
      my.luastatus # Status bar generator
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
        ];
      })
    ];

    home.configFile."dwm" = {
      source = "${configDir}/junnun/dwm";
      recursive = true;
    };
  };
}
