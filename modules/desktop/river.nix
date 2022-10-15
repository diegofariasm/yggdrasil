{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.river;
  configDir = config.dotfiles.configDir;
  riverSession = ''
    [Desktop Entry]
    Name=none+river
    Comment=Dynamic wayland compositor
    Exec=river
    Type=Application
  '';

in
{
  options.modules.desktop.river = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
    };

    home.packages = with pkgs; [
      (river.overrideAttrs (prevAttrs: rec {
        postInstall =
          ''
            mkdir -p $out/share/wayland-sessions
            echo "${riverSession}" > $out/share/wayland-sessions/river.desktop
          '';
        passthru.providedSessions = [ "river" ];
      }))
      rofi
      waybar
      wayland
      xwayland
      swaybg
    ];

    services.xserver.displayManager.sessionPackages = [
      (pkgs.river.overrideAttrs
        (prevAttrs: rec {
          postInstall =
            ''
              mkdir -p $out/share/wayland-sessions
              echo "${riverSession}" > $out/share/wayland-sessions/river.desktop
            '';
          passthru.providedSessions = [ "river" ];
        })
      )
    ];

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "river" = {
        source = "${configDir}/river";
        recursive = true;
      };
    };
  };
}

