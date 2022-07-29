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
            url = "https://github.com/fushiii/dwm/archive/3ee954dc05e122c0c5338e6c4b05af23fd93271d.tar.gz";
            sha256 = "08n4aaya2dmr186pwyafyy91ch94y8si233y5j27c7nmz6qgbrsv";

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
      picom
      # uptime -p
      procps
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
      source = "${configDir}/dwm";
      recursive = true;
    };
  };
}
