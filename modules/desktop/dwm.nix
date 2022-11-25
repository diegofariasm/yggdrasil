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
          preBuild = ''
            NIX_CFLAGS_COMPILE+="-O3 -march=native"
          '';
          src = builtins.fetchTarball {
            url = "https://github.com/fushiii/dwm/archive/37e273fd1bbb6439f5dfd712ee17c553821989e6.tar.gz";
            sha256 = "0ibijh925c5463iviln3ijap7ffvpp9r9qf7nd9i3h3s11qps3iz";

          };
          nativeBuildInputs = with pkgs; [ xorg.libX11 imlib2 ];
        });
      })
    ];

    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      windowManager.dwm.enable = true;
    };

    home.packages = with pkgs; [
      my.luastatus # Status bar generator
      sxhkd # Keybinds
      picom # Pretty visual effects
      procps # dmenu uptime
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

    home.configFile = {

      "dwm" = {
        source = "${configDir}/dwm";
        recursive = true;
      };
      "picom.conf".source = "${configDir}/dwm/picom.conf";
    };

  };
}
