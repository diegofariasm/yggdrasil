{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.shell.elvish;
in {
  options.modules.shell.elvish = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the elvish shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = with pkgs; [
        elvish
      ];
    }
    (lib.mkIf config.modules.roots.enable {
      home.file = {
        ".elvishrc".source = "${config.modules.roots.directory}/.elvishrc";
      };

      xdg.configFile = {
        elvish.source = "${config.modules.roots.directory}/.config/elvish";
      };
    })
  ]);
}
