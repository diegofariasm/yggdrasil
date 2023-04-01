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
  options.modules.desktop.dwm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    nixpkgs.overlays = [
      (final: prev: {
        dwm = prev.dwm.overrideAttrs (oldAttrs: {
          preBuild = ''
            NIX_CFLAGS_COMPILE+="-O3 -march=native"
          '';
          src = builtins.fetchTarball {
            url = "https://github.com/fushiii/dwm/archive/370fff6deae19c3be36201f376ddaae2d9c337e4.tar.gz";
            sha256 = "1h5hfjlyw6nfw5vnrdq6vzryypi3w1bpnidiyg2ywv9n477gph0d";
          };
          buildInputs = with pkgs; oldAttrs.buildInputs ++ [
            imlib2
          ];
        });
      })
    ];

    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      displayManager.lightdm.enable = true;
    };

    fonts.fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Iosevka"
        ];
      })
    ];

    # Add the needed binaries to PATH
    env.PATH = [
      "$HOME/.config/dwm/bin"
    ];

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
