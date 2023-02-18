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
            url = "https://github.com/fushiii/dwm/archive/ee206ed3f2a03e722b4e33cf20b3d8899fc438a9.tar.gz";
            sha256 = "1kmvm3dmc49lh2zdmm989gbd04q02yx11p65p20drjwqp4rccdqq";
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

      (final: prev: {
        dmenu = prev.dmenu.overrideAttrs (oldAttrs: {
          src = builtins.fetchTarball {
            url = "https://github.com/fushiii/dmenu/archive/1049c793127fc0eef15a530513c2fe4bcc82eedd.tar.gz";
            sha256 = "04x859k4m6nddl4fl3cdjd29syr2zwb648nhvg4gbcakf5n5g1ln";
          };
        });
      })
    ];

    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = "none+dwm";
        sddm = {
          enable = true;
        };
      };
      windowManager.dwm.enable = true;
    };

    # Screen lock
    programs.slock.enable = true;
    home.packages = with pkgs; [
      feh # Wallpaper setter
      pamixer # Audi controller
      dmenu # Launcher
      procps # dmenu uptime
      my.luastatus # Status bar generator
      brightnessctl # Brightness controller
      networkmanager_dmenu # Network controller     
    ];

    home.configFile."dwm" = {
      source = "${configDir}/dwm";
      recursive = true;
    };

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
  };
}
