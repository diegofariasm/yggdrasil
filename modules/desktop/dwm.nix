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
            url = "https://github.com/fushiii/dwm/archive/8a179562ca0b8f8560a720d78abb1a5a1638f5cd.tar.gz";
            sha256 = "1d3i9fd3gbcnmx8xi0253fb10yw98ga1ja15r2585c3x5zd7f98m";
          };
          buildInputs = with pkgs; oldAttrs.buildInputs ++ [
            imlib2
          ];
        });
      })

    ];

    # Needed modules for this desktop
    modules.desktop.term.st.enable = true;

    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      displayManager.lightdm = {
        enable = true;
      };
    };

    programs.slock.enable = true;
    user.packages = with pkgs; with my; [
      luastatus
    ];

    home.configFile = {
      "dwm" = {
        source = "${configDir}/dwm";
        recursive = true;
      };
    };
  };
}
