{
  #  osConfig,
  config,
  lib,
  ...
}: let
  cfg = config.modules.roots;
  projectsDir = config.xdg.userDirs.extraConfig.projects;
  roots = "${projectsDir}/roots";
  rootsDirectory = config.lib.file.mkOutOfStoreSymlink config.home.mutableFile."${roots}".path;
in {
  options.modules.roots = {
    enable = lib.mkOption {
      description = ''
        Whether to install your roots
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };

    directory = lib.mkOption {
      description = ''
        The directory to your roots
      '';
      type = lib.types.str;
      default = "${rootsDirectory}";
    };
  };

  config =
    lib.mkIf cfg.enable
    (lib.mkMerge [
      {
        home.mutableFile."${roots}" = {
          url = "https://github.com/baldur/roots.git";
          type = "git";
        };
      }

      # (lib.mkIf (osConfig.modules.desktop.hypr.enable) # Check if nested attribute exists
      #   {
      #     xdg.configFile = {
      #       hypr.source = "${rootsDirectory}/.config/hypr";
      #     };
      #   })
    ]);
}
