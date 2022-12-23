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
             url = "https://github.com/fushiii/dwm/archive/7801c03280435c45d2e7c72bbe8a3146c229760b.tar.gz";
             sha256 = "0hjvwcagpdvngm1x7ja9xbsw8wv0293dcd8jsmg2z71fn0mvnry8";
           };
          nativeBuildInputs = with pkgs; [ xorg.libX11 imlib2 ];
        });
      })
    ];

    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = "none+dwm";
        lightdm.enable = true;
      };
      windowManager.dwm.enable = true;
    };


    home.packages = with pkgs; [
      my.luastatus # Status bar generator
      feh # Wallpaper setter
      procps # dmenu uptime
      pamixer
    ];

    fonts.fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Iosevka"
        ];
      })
    ];

    home.configFile."dwm" = {
      source = "${configDir}/dwm";
      recursive = true;
    };

  };
}
