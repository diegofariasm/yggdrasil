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
    user.packages = with pkgs; [

      (river.overrideAttrs (prevAttrs: rec {
        postInstall =
          let
            riverSession = ''
              [Desktop Entry]
              Name=River
              Comment=Dynamic Wayland compositor
              Exec=river
              Type=Application
            '';
          in
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

    ];

    services.xserver.displayManager.sessionPackages = [
      (pkgs.river.overrideAttrs
        (prevAttrs: rec {
          postInstall =
            let
              riverSession = ''
                [Desktop Entry]
                Name=River
                Comment=Dynamic Wayland compositor
                Exec=river
                Type=Application
              '';
            in
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

