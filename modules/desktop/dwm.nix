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
            url = "https://github.com/fushiii/dwm/archive/8d77e96021bb4707aa3a8423782c43552b84547c.tar.gz";
            sha256 = "02lvbka0lhbpq8jk0j9xvbgb8b1bhqq2fanzf3d5chl2jd05fmvg";
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

    programs.slock.enable = true;
    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      displayManager.startx.enable = true;
    };

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
    # Add the needed binaries to PATH
    env.PATH = [
        "$HOME/.config/dwm/bin"
    ];

    home = {
      packages = with pkgs; with my; [
        rofi
        luastatus
        networkmanager_dmenu
      ];
      file.".xinitrc".source = "${configDir}/dwm/xinitrc";

      configFile = {

      "dwm" = {
        source = "${configDir}/dwm";
        recursive = true;
      };

      "networkmanager-dmenu" = {
        source = "${configDir}/networkmanager-dmenu";
        recursive = true;
      };

    };

   };

  };
}
