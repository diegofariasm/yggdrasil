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
  binDir = config.dotfiles.binDir;
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
            url = "https://github.com/fushiii/dwm/archive/bbd980b73d12959410f61c246ea40349d58e67f9.tar.gz";
            sha256 = "080kh7wki0f4mlkdj83xlrggh33q22f05lcyx8b5v6xp28glpm94";
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

    # Display manager
    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      displayManager.lightdm = {
        enable = true;
      };
    };
 fonts.fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Iosevka"
        ];
      })
    ];

    # Screen slocker
    programs.slock.enable = true;
    home = {
    # Some other apps
      packages = with pkgs; with my; [
        rofi
        xclip
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
