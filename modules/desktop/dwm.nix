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
            url = "https://github.com/fushiii/dwm/archive/a6a7c6857cbf741f610b1ac0ca0bf2bd16753bfc.tar.gz";
            sha256 = "199hya41sfhkszm3m98myyfwdvkknp346b6qayjrhpf1g77p1lq6";
          };
        });
      })

      (final: prev: {
        slock = prev.slock.overrideAttrs (oldAttrs: {
          src = builtins.fetchTarball {
            url = "https://github.com/fushiii/slock/archive/31e20a16fc977745d7279c637a4377650c303112.tar.gz";
            sha256 = "075yl91v9sypnpwsr6kyvzql8k3apjwpzvvjwai69xmpn255433x";
          };
          buildInputs = with pkgs; oldAttrs.buildInputs ++ [
            imlib2
          ];
        });
      })
    ];

    services.xserver.enable = true;
    services.xserver.windowManager.dwm.enable = true;
    services.xserver.displayManager.startx.enable = true;

    programs.slock.enable = true;
    fonts.fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Iosevka"
          "SourceCodePro"
          "Hack"
          "Meslo"
        ];
      })
    ];

    home = {
      packages = with pkgs; [
        feh
        procps
        pamixer
        rofi
        rofi-calc
        my.luastatus
        brightnessctl
        networkmanager_dmenu
      ];

      file.".Xresources".source = "${configDir}/dwm/xresources";
      file.".xinitrc".source = "${configDir}/dwm/xinitrc";

      configFile."rofi" = {
        source = "${configDir}/rofi";
        recursive = true;
      };

      configFile."dwm" = {
        source = "${configDir}/dwm";
        recursive = true;
      };

      configFile."networkmanager-dmenu" = {
        source = "${configDir}/networkmanager-dmenu";
        recursive = true;
      };

    };
  };
}
