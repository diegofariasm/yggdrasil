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
            url = "https://github.com/fushiii/dwm/archive/800a5fe823ba7959f4c14a95c0e24f727fab7cf5.tar.gz";
            sha256 = "11fpj6lhfcym9kxssa2dxzlng5xvxjlxlpfwmvwq9ac0kfx4qmbg";
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

    # Screen slocker
    programs.slock.enable = true;
    home = {
    # Some other apps
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
