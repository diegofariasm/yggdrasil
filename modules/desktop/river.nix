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
      displayManager.gdm.enable = true;
    };
    user.packages = with pkgs; [
      river
      rofi
      waybar
      wayland
      xwayland

    ];
    services.xserver.windowManager.session = singleton {
      name = "river";
      start = ''
        '${pkgs.river}/bin/river';
      '';
    };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "river" = {
        source = "${configDir}/river";
        recursive = true;
      };
    };
  };
}

