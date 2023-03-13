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
            url = "https://github.com/fushiii/dwm/archive/b0fbe15ca4e33e7b26196c00c7dc4b78d672ee72.tar.gz";
            sha256 = "1czidhc1dqfjs970nc3cn56p21d0vk3ka9wl7z0wsd7khwmcmvmh";
          };
          buildInputs = with pkgs; oldAttrs.buildInputs ++ [
            imlib2
          ];
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

    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      displayManager.lightdm.enable = true;
    };

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
        rofi
        pamixer
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
